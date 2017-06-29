class Article < ApplicationRecord
  include Dateable
  include PgSearch
  include AlgoliaSearch

  extend ActionView::Helpers::DateHelper
  extend FriendlyId

  has_attachments :images, maximum: 20, accept: [:jpg, :png, :gif]

  has_paper_trail on: [:update, :destroy],
    only: [:title, :content], ignore: :change_last_communicated_at

  def should_generate_new_friendly_id?
    !has_friendly_id_slug? or title_changed?
  end

  def has_friendly_id_slug?
    slugs.where(slug: friendly_id).exists?
  end

  algoliasearch do
    # all attributes will be sent to build the Algolia records
    # or we can uncomment following line and send specific attributes:
    # attribute :author_id, :created_at, :title, :content, :visits

    # the `searchableAttributes` (formerly known as attributesToIndex) setting defines the
    # attributes you want to search in
    searchableAttributes ['title', 'content']

    # the `attributesToSnippet` lets us specify which attributes we want to be able to get
    # search for snippets (i.e. parts of the text that contain the query)
    attributesToSnippet ['content:10']

    # the `customRanking` setting defines the ranking criteria use to compare two matching
    # records in case their text-relevance is equal. It should reflect the record popularity.
    customRanking ['desc(updated_at)']
  end

  FRESHNESS_LIMIT = 7.days
  STALENESS_LIMIT = 6.months

  FRESH = "This article is accurate."
  OUTDATED = "This article needs major updates."
  FRESHNESS = "Updated in the last #{distance_of_time_in_words(FRESHNESS_LIMIT)}."
  STALENESS = "Updated over #{distance_of_time_in_words(STALENESS_LIMIT)} ago."
  OUTDATEDNESS = "Deemed in need of an update."
  POPULARITY = "Endorsed, subscribed, & visited."
  ARCHIVAL = "Outdated & ignored in searches."

  pg_search_scope :search,
    against: {
      title: 'A',
      content: 'B'
    },
    using: {
      tsearch: { dictionary: "english", prefix: true },
      trigram: { threshold:  0.3 }
    }

    # ranked_by: ":trigram"

  friendly_id :title, use: [:slugged, :history]

  belongs_to :author, class_name: "User"
  belongs_to :editor, class_name: "User"
  belongs_to :outdatedness_reporter, class_name: "User"

  has_many :articles_tags, dependent: :destroy
  has_many :articles_categories, dependent: :destroy
  has_many :update_requests, dependent: :destroy
  has_many :tags, through: :articles_tags, counter_cache: :tags_count
  has_many :categories, through: :articles_categories
  has_many :subscriptions, class_name: "ArticleSubscription", dependent: :destroy
  has_many :subscribers, through: :subscriptions, class_name: "User", source: :user
  has_many :endorsements, class_name: "ArticleEndorsement", dependent: :destroy
  has_many :endorsers, through: :endorsements, class_name: "User", source: :user
  has_many :views

  attr_reader :tag_tokens, :category_tokens

  validates :title, presence: true

  after_save :update_subscribers
  after_save :notify_slack
  after_destroy :notify_slack

  scope :archived, -> { where.not(archived_at: nil) }
  scope :current, -> do
    where(archived_at: nil)
      .order(outdated_at: :desc, updated_at: :desc, created_at: :desc)
  end
  scope :fresh, -> do
    where(%Q["articles"."updated_at" >= ?], FRESHNESS_LIMIT.ago)
      .where(archived_at: nil, outdated_at: nil)
  end
  scope :popular, -> do
    order(endorsements_count: :desc, subscriptions_count: :desc, visits: :desc)
  end
  scope :outdated,  -> { where.not(outdated_at: nil) }
  scope :stale,   -> do
    where(%Q["articles"."updated_at" < ?], STALENESS_LIMIT.ago)
  end
  scope :alphabetical, -> { order(title: :asc) }

  def self.count_visit(article_instance)
    self.increment_counter(:visits, article_instance.id)
  end

  def self.reset_tags_count
    pluck(:id).each do |article_id|
      reset_counters(article_id, :tags)
    end
  end

  def self.searchable_language
    'english'
  end

  def self.text_search(query, scope = nil)
    scope ||= current

    if query.present?
      scope.search(query).with_pg_search_highlight
    else
      scope
    end
  end

  def author?(user)
    self.author == user
  end

  def archive!
    update_attributes(archived_at: Time.current)
  end

  def archived?
    archived_at.present?
  end

  def different_editor?
    author != editor
  end

  def edited?
    self.editor.present?
  end

  def fresh?
    !archived? && !outdated? && updated_at >= FRESHNESS_LIMIT.ago
  end

  def never_notified_author?
    self.last_notified_author_at.nil?
  end

  def stale?
    updated_at < STALENESS_LIMIT.ago
  end

  def outdated?
    outdated_at.present?
  end

  def refresh!
    update_attributes(outdated_at: nil)
    touch(:updated_at)
  end

  def never_notified_author?
    self.last_notified_author_at.nil?
  end

  # might need description here
  def outdated!(user_id, description = '')
    update(outdated_at: Time.current, outdatedness_reporter_id: user_id)
    SendArticleOutdatedJob.perform_later(id, user_id, description)
  end

  def recently_notified_author?
    return false if never_notified_author?
    self.last_notified_author_at > 1.week.ago.beginning_of_day
  end

  def ready_to_notify_author_of_staleness?
    self.never_notified_author? or !self.recently_notified_author?
  end

  # excluding can be a user instance that needs to be excluded from the list
  # of contributors, for instance to avoid notifying someone about something
  # they did on an article they're a contributor to.
  def contributors(excluding: nil)
    [author, editor].uniq.reject do |user|
      user == excluding
    end
  end

  def count_visit
    self.class.count_visit(self)
  end

  # @user - the user to have endorse this article
  # Returns the endorsement if successfully created
  # Raises otherwise
  def endorse_by(user)
    self.endorsements.find_or_create_by!(user: user)
  end

  # @user - the user to subscribe to this article
  # Returns the subscription if successfully created
  # Raises otherwise
  def subscribe(user)
    self.subscriptions.find_or_create_by!(user: user)
  end

  def subscribers_to_update
    subscriptions.reject { |s| s.user == editor }
  end

  def category_tokens=(tokens)
    self.category_ids = Category.ids_from_tokens(tokens)
  end

  def tag_tokens=(tokens)
    self.tag_ids = Tag.ids_from_tokens(tokens)
  end

  def to_s
    title
  end

  def unarchive!
    update_attributes(archived_at: nil)
  end

  # @user - the user to unendorse this article for
  # Returns true if the unendorsement was successful
  # Returns false if there was no endorsement in the first place
  def unendorse_by(user)
    endorsement = self.endorsements.find_by(user: user)
    return false if endorsement.nil?
    return true if endorsement.destroy
  end

  # @user - the user to unsubscribe from this article
  # Returns true if the unsubscription was successful
  # Returns false if there was no subscription in the first place
  def unsubscribe(user)
    subscription = self.subscriptions.find_by(user: user)
    return false if subscription.nil?
    return true if subscription.destroy
  end

  # @user - the user to create an article vide for
  # Returns the article view if successfully created
  # Raises otherwise
  def view(user:)
    existing_view = views.find_by(user: user)

    if existing_view.present?
      existing_view.increment_count

      existing_view.save!
    else
      new_view = views.create!(user: user)
    end
  end

  def self.tokens(query)
    articles = where(%Q["articles"."title" ILIKE ?], "%#{query}%")
    new_article = { id: "<<<#{query}>>>", title: "New: \"#{query}\"" }

    if articles.empty?
      [new_article]
    else
      results = articles.collect { |t| Hash["id" => t.id, "title" => t.title] }
      results.unshift(new_article) if articles.select { |t| t.title.downcase == query.downcase }.empty?
      results
    end
  end

  # Returns array of article ids from tokens
  def self.ids_from_tokens(tokens)
    tokens.gsub!(/<<<(.+?)>>>/) { create!(title: $1).id }
    tokens.split(",")
  end

  private

  def created?
    created_at == updated_at
  end

  def notify_slack
    Speakerphone.new(self, state).shout
  end

  def state
    if destroyed?
      :destroyed
    elsif created?
      :created
    elsif archived_at?
      :archived
    elsif outdated_at?
      :outdated
    else
      :updated
    end
  end

  def update_subscribers
    subscribers_to_update.each do |subscription|
      subscription.send_update
    end
  end
end

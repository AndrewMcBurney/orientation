class Tag < ApplicationRecord
  extend FriendlyId

  has_many :articles_tags, dependent: :destroy
  has_many :articles, through: :articles_tags, counter_cache: :articles_count

  validates :name, uniqueness: { case_sensitive: false }

  scope :more_than_one_article, -> { where('articles_count > 1') }

  friendly_id :name

  def to_s
    name
  end

  def to_param
    slug
  end

  def self.by_article_count
    order(articles_count: :desc)
  end

  def self.reset_articles_count
    pluck(:id).each do |tag_id|
      reset_counters(tag_id, :articles)
    end
  end
end

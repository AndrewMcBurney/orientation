# frozen_string_literal: true

class ArticlesController < ApplicationController
  include ArticlesHelper

  before_action :set_paper_trail_whodunnit, only: [
    :update,
    :destroy
  ]
  before_action :find_article_by_params, only: [
    :show,
    :edit,
    :update,
    :destroy
  ]
  before_action :decorate_article, only: [
    :show,
    :edit,
    :toggle_archived,
    :toggle_subscription,
    :toggle_endorsement,
    :report_outdated,
    :mark_fresh
  ]
  before_action :fetch_articles_with_filter, only: [
    :fresh,
    :stale,
    :outdated,
    :archived
  ]
  respond_to :html, :json

  def index
    @articles = fetch_articles
    @ordered_articles = Article.order(:title).limit(1000)

    respond_with do |format|
      format.html { render :index, layout: false if request.xhr? }
      format.js   { render :index, layout: false }
      format.json do
        render json: TokenQuerier.new(query: params[:q], model: @ordered_articles, attribute: "title").tokens
      end
    end
  end

  def show
    respond_with_article_or_redirect_or_new
    record_article_metrics
  end

  def new
    @article = Article.new(title: params[:title]).decorate
  end

  def create
    @article = Article.new(article_params)
    if @article.save
      @article.subscribe(@article.author)
      ArticleLinksService.new(@article).find_broken_links

      flash[:notice] = "Article was successfully created."
    else
      flash[:error] = error_message(@article)
    end
    respond_with @article
  end

  def edit
    @tags = @article.tags.collect { |t| Hash["id" => t.id, "name" => t.name] }
    @categories =
      @article.categories.collect { |c| Hash["id" => c.id, "label" => c.label] }
  end

  def fresh
    @page_title = "Fresh Articles"
    render_search_page
  end

  def stale
    @page_title = "Stale Articles"
    render_search_page
  end

  def outdated
    @page_title = "Outdated Articles"
    render_search_page
  end

  def archived
    @page_title = "Archived Articles"
    render_search_page
  end

  def popular
    @articles = fetch_articles(Article.current.popular)
    @page_title = "Popular Articles"
    render_search_page
  end

  def toggle_archived
    !@article.archived? ? @article.archive! : @article.unarchive!

    flash[:notice] = "Successfully #{@article.archived? ? "archived" : "unarchived"} this article."
    respond_with_article_or_redirect
  end

  def mark_fresh
    if @article.refresh!
      respond_with_article_or_redirect
    end
  end

  def report_outdated
    @article.outdated!(current_user.id)
    flash[:notice] = "Successfully reported this article as outdated."
    respond_with_article_or_redirect
  end

  def update
    if @article.update_attributes(article_params)
      ArticleLinksService.new(@article).refresh_broken_links
      flash[:notice] = "Article was successfully updated."
    else
      flash[:error] = error_message(@article)
    end
    respond_with @article
  end

  def destroy
    redirect_to articles_url if @article.destroy
  end

  def toggle_subscription
    if !current_user.subscribed_to?(@article)
      @article.subscribe(current_user)
      flash[:notice] = "You will now receive email notifications when this article is updated."
    else
      @article.unsubscribe(current_user)
      flash[:notice] = "You will no longer receive email notifications when this article is updated."
    end

    respond_with_article_or_redirect
  end

  def toggle_endorsement
    if !current_user.endorsing?(@article)
      @article.endorse_by(current_user)
      flash[:notice] = "Thanks for taking the time to make someone feel good about their work."
    else
      @article.unendorse_by(current_user)
      flash[:notice] = "Giving it, then taking it right back. Ruthless, aren't we?"
    end

    respond_with_article_or_redirect
  end

  def subscriptions
    @subscriptions = decorate_article.subscriptions.decorate
  end

  def search
    if search_title_only?
      @articles = fetch_articles_by_title
    else
      @articles = fetch_articles
    end

    render_search_page
  end

  private

  def error_message(article)
    if article.errors.messages.key?(:friendly_id)
      "#{article.title} is a reserved word."
    else
      "Article could not be #{params[:action]}d."
    end
  end

  def article_params
    params.require(:article).permit(
      :created_at, :updated_at, :title, :content, :tag_tokens, :category_tokens,
      :author_id, :editor_id, :archived_at, images: [])
  end

  def decorate_article
    @article = ArticleDecorator.new(find_article_by_params)
  end

  def fetch_articles_with_filter
    @articles = fetch_articles(Article.current.public_send(action_name), action_name)
  end

  def render_search_page
    respond_to do |format|
      format.html { render :index }
      format.js   { render :index, layout: false }
    end
  end

  def fetch_articles_by_title
    scope = Article.current
    collection = scope.where('lower(title) like ?', "%#{params[:search].downcase}%")
    ArticleDecorator.decorate_collection(collection)
  end

  def fetch_articles(scope = nil, filter = nil)
    scope  ||= Article.current
    @count ||= scope.try(:count) || 0
    search_results = Algolia::Index.new("Article").search(params[:search], { tagFilters: filter })["hits"]
    results = search_results.collect { |a| scope.where(title: a["title"])[0] }.compact

    ArticleDecorator.decorate_collection(results, context: { search_params: params[:search] })
  end

  def find_article_by_params
    @article ||= begin
      Article.friendly.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      Article.friendly.none
    end
  end
  helper_method :article

  def respond_with_article_or_redirect_or_new
    if @article.present?
      respond_with_article_or_redirect
    else
      flash[:notice] = "Since this article doesn't exist, it would be super nice if you wrote it. :-)"
      redirect_to new_article_path(title: params[:id].titleize)
    end
  end

  def respond_with_article_or_redirect
    # If an old id or a numeric id was used to find the record, then
    # the request path will not match the post_path, and we should do
    # a 301 redirect that uses the current friendly id.

    if request.path != article_path(@article)
      return redirect_to @article, status: :moved_permanently
    else
      return respond_with @article
    end
  end

  def record_article_metrics
    if @article.present?
      @article.count_visit
      @article.view(user: current_user)
    end
  end
end

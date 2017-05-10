class GuidesController < ApplicationController
  include ArticlesHelper

  def index
    @guides = ArticleDecorator.decorate_collection(guides)
    @articles = ArticleDecorator.decorate_collection(articles)

    redirect_to(articles_path) if @guides.empty?
  end

  private
  #NOTE
  #def find_article_by_params
  #  @article ||= (Article.guide.find_by_slug(params[:id]) or Article.guide.find(params[:id]))
  #end

  def guides
    Article.guide.current.alphabetical
  end

  def articles
    Article.includes(:tags).current
  end
end

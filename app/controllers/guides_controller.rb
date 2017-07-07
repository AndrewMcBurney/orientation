class GuidesController < ApplicationController
  include ArticlesHelper

  def index
    @count = count
    @guides = ArticleDecorator.decorate_collection(guides)
    @articles = ArticleDecorator.decorate_collection(articles)

    redirect_to(articles_path) if @guides.empty?
  end

  private

  def count
    articles.try(:count) || 0
  end

  def guides
    Article.guide.current.alphabetical
  end

  def articles
    Article.includes(:tags).current
  end
end

# frozen_string_literal: true

#
# Categories controller for article aggregations
#
class CategoriesController < ApplicationController
  before_action :set_articles, only: [:index, :show]
  before_action :set_categories, only: [:index, :show]
  before_action :set_category, only: [:show, :edit, :update, :destroy]

  # GET /categories
  def index
    @ordered_categories = Category.order(:label)

    respond_with do |format|
      format.html { render :index }
      format.json { render json: @ordered_categories.tokens(params[:q]) }
    end
  end

  # GET /categories/:friendly_id
  def show
    @category_articles = @category.articles
  end

  # GET /categories/new
  def new
    @category = Category.new
  end

  # GET /categories/:friendly_id/edit
  def edit
    @category_articles =
      @category.articles.collect { |a| Hash["id" => a.id, "title" => a.title] }
  end

  # POST /categories
  def create
    @category = Category.new(category_params)

    if @category.save
      redirect_to @category, notice: "Category was successfully created."
    else
      render :new, notice: "Category not created."
    end
  end

  # PATCH/PUT /categories/:friendly_id
  def update
    if @category.update(category_params)
      redirect_to @category, notice: "Category was successfully updated."
    else
      render :edit
    end
  end

  # DELETE /categories/:friendly_id
  def destroy
    @category.destroy
    redirect_to categories_url, notice: "Category was successfully destroyed."
  end

  private

  def articles
    Article.includes(:tags).current
  end

  def set_articles
    @articles = ArticleDecorator.decorate_collection(articles)
  end

  def categories
    Category.order(:label)
  end

  def set_category
    @category = Category.friendly.find(params[:id])
  end

  def set_categories
    @categories = CategoryDecorator.decorate_collection(categories)
  end

  def category_params
    params.require(:category).permit(:label, :article_tokens)
  end
end

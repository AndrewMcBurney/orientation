# frozen_string_literal: true

class ArticleFactory < ModelFactory
  attr_reader :model, :attribute
  def initialize
    @model     = Article
    @attribute = "title"
  end
end

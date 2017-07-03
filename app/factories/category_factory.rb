# frozen_string_literal: true

class CategoryFactory < ModelFactory
  attr_reader :model, :attribute
  def initialize
    @model     = Category
    @attribute = "label"
  end
end

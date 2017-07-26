# frozen_string_literal: true

class TagFactory < ModelFactory
  attr_reader :model, :attribute
  def initialize
    @model     = Tag
    @attribute = "name"
  end
end

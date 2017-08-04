# frozen_string_literal: true

class BrokenLinksFactory < ModelFactory
  attr_reader :model, :attribute
  def initialize
    @model     = BrokenLink
    @attribute = "url"
  end

  def build(args)
    model.find_or_create_by(args)
  end
end

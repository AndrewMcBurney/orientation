# frozen_string_literal: true

#
# ModelFactory.rb
# Abstract factory which builds an array of objects from an array of attributes
#
class ModelFactory
  def build(attributes)
    attributes.map { |a| model.create!(attribute => a) }
  end
end

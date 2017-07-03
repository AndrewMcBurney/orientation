# frozen_string_literal: true

#
# Queries database for given model attribute, and returns hash 'token' representation of collection
# returned
#
class TokenQuerier
  include DelimiterHelper

  attr_reader :query, :model, :attribute, :collection, :item
  def initialize(args)
    @query = args[:query]
    @model = args[:model]
    @attribute = args[:attribute]
  end

  def tokens
    query_tokens
    parse_results
  end

  private

  def query_tokens
    @collection = model.where(%("#{model.table_name}"."#{attribute}" ILIKE ?), "%#{query}%")
    @item = { id: delimit_string(query), attribute => "New: \"#{query}\"" }
  end

  def parse_results
    if collection.empty?
      [item]
    elsif search_attribute_not_in_query?
      id_attributes.unshift(item)
    else
      id_attributes
    end
  end

  def id_attributes
    collection.collect { |c| Hash["id" => c.id, attribute => c[attribute]] }
  end

  def search_attribute_not_in_query?
    collection.select { |c| c[attribute].casecmp(query) }.empty?
  end
end

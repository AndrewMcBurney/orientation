# frozen_string_literal: true

#
# TokenParser.rb
# Helpers methods for parsing tokens
#
# NOTE: 'tokens' is an array comprised of preexisting ids for initialized objects,
# and attributes delimited by <<<>>>>
#
class TokenParser
  include DelimiterHelper

  attr_reader :tokens
  def initialize(token_string)
    @tokens = token_string.split(",")
  end

  def parse_token_string
    model_attributes, existing_ids = split_tokens
    attributes = model_attributes.map { |a| strip_delimiter(a) }
    [attributes, existing_ids]
  end

  # Separates the existing ids from the attrbutes belonging to uninitialized model
  # objects based on the <<<>>> delimiter
  def split_tokens
    tokens.partition { |token| match_delimiter_string(token) }
  end
end

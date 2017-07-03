# frozen_string_literal: true

class Category < ApplicationRecord
  extend FriendlyId

  has_many :articles_categories, dependent: :destroy
  has_many :articles, through: :articles_categories

  validates :label, uniqueness: { case_sensitive: false }

  friendly_id :label, use: [:slugged, :history]

  attr_reader :article_tokens

  def article_tokens=(tokens)
    attributes, existing_ids = TokenParser.new(tokens).parse_token_string
    new_ids = ArticleFactory.new.build(attributes).map(&:id)
    self.article_ids = existing_ids + new_ids
  end
end

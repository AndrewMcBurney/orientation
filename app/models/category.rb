# frozen_string_literal: true

class Category < ApplicationRecord
  extend FriendlyId

  attr_reader :article_tokens
  friendly_id :label, use: [:slugged, :history]

  validates :label, presence: true

  has_many :category_guide_associations, dependent: :destroy
  has_many :articles, through: :category_guide_associations

  def article_tokens=(tokens)
    self.article_ids = Article.ids_from_tokens(tokens)
  end
end

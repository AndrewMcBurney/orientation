# frozen_string_literal: true

class Category < ApplicationRecord
  extend FriendlyId

  friendly_id :label, use: [:slugged, :history]

  validates :label, presence: true

  has_many :category_guide_associations, dependent: :destroy
  has_many :articles, through: :category_guide_associations

  attr_reader :article_tokens

  def article_tokens=(tokens)
    self.article_ids = Article.ids_from_tokens(tokens)
  end
end

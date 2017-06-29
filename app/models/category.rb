# frozen_string_literal: true

class Category < ApplicationRecord
  extend FriendlyId

  has_many :articles_categories, dependent: :destroy
  has_many :articles, through: :articles_categories

  validates :label, uniqueness: { case_sensitive: false }

  friendly_id :label, use: [:slugged, :history]

  attr_reader :article_tokens

  def article_tokens=(tokens)
    self.article_ids = Article.ids_from_tokens(tokens)
  end

  def self.tokens(query)
    categories = where(%Q["categories"."label" ILIKE ?], "%#{query}%")
    new_category = { id: "<<<#{query}>>>", label: "New: \"#{query}\"" }

    if categories.empty?
      [new_category]
    else
      results = categories.collect { |t| Hash["id" => t.id, "label" => t.label] }

      if categories.select { |t| t.label.downcase == query.downcase }.empty?
        results.unshift(new_category)
      end

      results
    end
  end

  # Returns array of category ids from tokens
  def self.ids_from_tokens(tokens)
    tokens.gsub!(/<<<(.+?)>>>/) { create!(label: $1).id }
    tokens.split(",")
  end
end

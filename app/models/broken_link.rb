# frozen_string_literal: true

class BrokenLink < ApplicationRecord
  belongs_to :article
  belongs_to :author, class_name: "User"
  validates  :article, :author, :url, presence: true

  # Two dimensional array grouping articles containing broken links
  def self.per_article
    uniq.pluck(:article_id)
      .map { |id| where(article_id: id) }
      .sort_by(&:size).reverse
  end
end

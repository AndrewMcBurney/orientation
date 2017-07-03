# frozen_string_literal: true

class ArticlesCategory < ApplicationRecord
  belongs_to :article
  belongs_to :category

  validates :article_id,
            uniqueness: { scope: :category_id, case_sensitive: false }
end

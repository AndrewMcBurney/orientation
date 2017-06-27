# frozen_string_literal: true

#
# TODO: Category association can either be between a category and a guide, or a
# category and another category (recursive)
#
class CategoryGuideAssociation < ApplicationRecord
  belongs_to :article
  belongs_to :category

  validates :article_id, presence: true
  validates :category_id, presence: true
end

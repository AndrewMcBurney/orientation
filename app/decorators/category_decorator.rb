# frozen_string_literal: true

class CategoryDecorator < ApplicationDecorator
  delegate_all

  def label
    object.try(:label) || "No label"
  end
end

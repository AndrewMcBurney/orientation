# frozen_string_literal: true

class BrokenLinksController < ApplicationController
  # GET /broken_links
  def index
    @broken_links_array = BrokenLink.per_article
  end
end

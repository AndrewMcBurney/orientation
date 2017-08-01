# frozen_string_literal: true

require Rails.root.join("app", "helpers", "application_helper.rb")
require Rails.root.join("app", "helpers", "broken_links_helper.rb")

desc "Nightly task to update list of broken article urls (runs at 1PM PST)"
namespace :links do
  include ApplicationHelper
  include BrokenLinksHelper

  task audit: :environment do
    # Remove old records
    BrokenLink.delete_all

    # Parse each article for broken links
    Article.find_each { |article| find_broken_links_for_article(article) }
  end
end

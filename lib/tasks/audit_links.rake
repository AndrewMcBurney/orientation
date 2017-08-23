# frozen_string_literal: true

desc "Nightly task to update list of broken article urls (runs at 1PM PST)"
namespace :links do
  task audit: :environment do
    # Remove old records
    BrokenLink.delete_all

    # Parse each article for broken links
    Article.find_each { |article| ArticleLinksService.new(article).find_broken_links }
  end
end

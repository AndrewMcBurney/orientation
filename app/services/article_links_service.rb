# frozen_string_literal: true

#
# ArticleLinksService.rb
# Helpers methods for finding broken links
#
class ArticleLinksService
  include ApplicationHelper

  attr_reader :article
  def initialize(article)
    @article = article
  end

  # Clears current listing of broken links
  def refresh_broken_links
    clear_broken_links
    find_broken_links
  end

  # Parses article to find broken links, and builds active record representations of them
  def find_broken_links
    markdown(
      article.content,
      build_links: true,
      article_params: { article_id: article.id, author_id: article.author.id }
    )
  end

  private

  # Removes all old 'BrokenLink' records for a given article
  def clear_broken_links
    BrokenLink.where(article_id: article.id).delete_all
  end
end

# frozen_string_literal: true

module BrokenLinksHelper
  def refresh_broken_links_for_article(article)
    clear_links_for_article(article)
    find_broken_links_for_article(article)
  end

  # Parses article to find broken links, and builds active record representations of them
  def find_broken_links_for_article(article)
    markdown(article.content, article_options(article))
  end

  private

  # Removes all old 'BrokenLink' records for a given article
  def clear_links_for_article(article)
    BrokenLink.where(article_id: article.id).delete_all
  end

  def article_options(article)
    {
      build_links: true,
      article_params: { article_id: article.id, author_id: article.author.id }
    }
  end
end

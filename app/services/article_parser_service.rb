# frozen_string_literal: true

#
# ArticleParserService.rb
# Helpers service for parsing articles in html_with_pygments.rb
#
class ArticleParserService
  attr_reader :full_document, :options, :permalinks, :external_permalinks, :broken_link_factory
  def initialize(options, full_document)
    @full_document       = full_document
    @options             = options
    @permalinks          = anchor_tags_current_page
    @external_permalinks = anchor_tags_external_pages || {}
    @broken_link_factory = BrokenLinksFactory.new
  end

  def article_link_status(link)
    return if valid_article?(link)
    broken_link_factory.build(link_params(link)) if build_links?
    "article-not-found"
  end

  def internal_link?(link)
    url = safe_url_parser(link)
    return false if url.blank?

    if url.absolute?
      root = Rails.application.routes.url_helpers.root_url(host: ENV.fetch("ORIENTATION_DOMAIN"))
      link.include?(root)
    else
      true
    end
  end

  def valid_article?(link)
    return true if anchor_tag?(link) || valid_external_anchor_tag?(link)

    url = safe_url_parser(link)
    return false if url.blank?

    link = url.path unless internal_link?(link)
    return false if link.nil?

    slug = link.split("/").last
    Article.friendly.find(slug)
  rescue ActiveRecord::RecordNotFound
    false
  end

  private

  # Match all anchor tags on an external link page
  #   @returns: hash mapping external url to value of its validity
  def anchor_tags_external_pages
    full_document.scan(%r{\[.*?\]\((\/.*)(#.*)\)})
      .map { |base, anchor| [base + anchor, valid_base_link?(base)] }
      .to_h
  end

  # Match all anchor tags on current article
  def anchor_tags_current_page
    full_document.scan(/\[.*?\]\((#.*)\)/).flatten
  end

  def safe_url_parser(link)
    URI.parse(link)
  rescue URI::InvalidURIError
    nil
  end

  def link_params(link)
    options[:article_params].merge(url: link)
  end

  def anchor_tag?(link)
    permalinks.include?(link)
  end

  def valid_external_anchor_tag?(link)
    return false unless external_permalinks
    external_permalinks[link]
  end

  def valid_base_link?(link)
    internal_link?(link) || valid_article?(link)
  end

  def build_links?
    options[:build_links]
  end
end

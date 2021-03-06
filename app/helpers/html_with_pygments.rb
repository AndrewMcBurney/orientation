# frozen_string_literal: true

class HtmlWithPygments < Redcarpet::Render::HTML
  attr_writer :options, :permalinks

  def header(title, level)
    permalink = title.parameterize.downcase
    %(
        <a id='#{permalink}' class='heading js-headingLink' href='##{permalink}'>
          <input class='heading-link js-headingLink-link' value='##{permalink}' readonly>
          <h#{level} class='heading-text js-headingLink-heading'>#{title}</h#{level}>
        </a>
    )
  end

  def block_code(code, language)
    safe_language = Pygments::Lexer.find_by_alias(language) ? language : nil

    sha = Digest::SHA1.hexdigest(code)
    Rails.cache.fetch ["code", safe_language, sha].join('-') do
      Pygments.highlight(code, lexer: safe_language)
    end
  end

  def link(link, title, content)
    if internal_link?(link) && !valid_article?(link)
      class_attribute = "class='#{article_status(link)}'"
    end
    title_attribute = "title='#{title}'" if title

    if class_attribute || title_attribute
      "<a href='#{link}' #{title_attribute} #{class_attribute}>#{content}</a>"
    else
      # Redcarpet doesn't allow calls to super in overidden
      # render methods due to C shenanigans:
      # https://github.com/vmg/redcarpet/issues/51#issuecomment-1922079
      "<a href='#{link}'>#{content}</a>"
    end
  end

  def normal_text(text)
    text.gsub!("[ ]", "<input type='checkbox'>") if text.match(/^\[{1}\s\]{1}/)
    text.gsub!("[x]", "<input type='checkbox' checked>") if text.match(/^\[{1}(x|X)\]{1}/)

    text
  end

  def preprocess(full_document)
    @permalinks = find_anchor_tags(full_document)

    # matches [[Article Title]] or [[article-title]] relative
    # links, see https://regex101.com/r/aR5bS0/1
    pattern = /\[{2}(.*?)\]{2}/

    if full_document.match(pattern)
      full_document.gsub!(pattern) do |match|
        text = match.delete("[[]]")
        "[#{text}](#{article_link(text.parameterize)})"
      end
    else
      full_document
    end
  end

  private

  def find_anchor_tags(full_document)
    # Match all anchor tags
    full_document.scan(/\[.*?\]\((#.*)\)/).flatten
  end

  def article_status(link)
    return if valid_article?(link)
    broken_link_factory.build(link_params(link)) if build_links?
    "article-not-found"
  end

  def article_link(article_title)
    Rails.application.routes.url_helpers.article_url(article_title, only_path: true)
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

  def anchor_tag?(link)
    @permalinks.include?(link)
  end

  def valid_article?(link)
    return true if anchor_tag?(link)

    link = safe_url_parser.path unless internal_link?(link)
    return false if link.nil?

    slug = link.split('/').last

    Article.friendly.find(slug)
  rescue ActiveRecord::RecordNotFound
    false
  end

  def safe_url_parser(link)
    URI.parse(link)
  rescue URI::InvalidURIError
    nil
  end

  def link_params(link)
    @options[:article_params].merge(url: link)
  end

  def broken_link_factory
    @broken_link_factory ||= BrokenLinksFactory.new
  end

  def build_links?
    @options[:build_links]
  end
end

# frozen_string_literal: true

module ApplicationHelper
  def body_class
    %|#{controller.controller_name} #{controller.controller_name}-#{controller.action_name} #{@body_class}|
  end

  def markdown(text, options = {})
    configure_markdown_parser(options)
    markdown_parser.render(text).html_safe
  end

  def table_of_contents(text)
    html_toc_parser.render(text).html_safe
  end

  ##
  # Takes a time and a string to represent it. Outputs a proper <time>
  # element with a title tag that display the raw time.
  #
  def time_element(time, css_class = 'js-time')
    time = time.in_time_zone
    time_tag time, ordinalized_date(time), title: time, class: css_class
  end

  # Convert a time into an ordinalized (June 3rd, 2016) date
  def ordinalized_date(time)
    time.to_date.to_s(:long_ordinal)
  end

  ##
  # Just like time_element, but relative to now.
  #
  def relative_time_element(time)
    time_element(time, 'js-relative-time')
  end

  def page_title(title)
    content_for(:page_title, raw(title))
  end

  def current_action?(name, css)
    action_name == name ? css : ''
  end

  private

  def configure_markdown_parser(options)
    markdown_parser.renderer.options = options
    markdown_parser.renderer.permalinks = []
  end

  def markdown_parser
    @markdown_parser ||= Redcarpet::Markdown.new(markdown_renderer, markdown_options.merge(footnotes: true))
  end

  def html_toc_parser
    @html_toc_parser ||= Redcarpet::Markdown.new(html_toc_renderer, markdown_options)
  end

  def markdown_renderer
    @markdown_renderer ||= HtmlWithPygments.new(hard_wrap: true, escape_html: true)
  end

  def html_toc_renderer
    @html_toc_renderer ||= Redcarpet::Render::HTML_TOC.new(nesting_level: 4)
  end

  def markdown_options
    {
      autolink: true,
      no_intra_emphasis: true,
      fenced_code_blocks: true,
      disable_indented_code_blocks: true,
      lax_spacing: true,
      lax_html_blocks: true,
      strikethrough: true,
      superscript: true,
      tables: true,
      with_toc_data: true
    }
  end
end

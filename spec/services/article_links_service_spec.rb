# frozen_string_literal: true

require "rails_helper"

RSpec.describe ArticleLinksService do
  let(:markdown) do
    <<~END
      # Markdown Sample With Broken Links

      ### broken-link-tag-1
      [1](/tags/broken-link-tag-1)

      ## Anchor Link Above

      ### anchor-link (not broken)
      [anchor-link-above](#anchor-link-above)
      [anchor-link-below](#anchor-link-below)

      ### anchor-tag, other page
      [3](/#search)

      ### broken-link-tag-2
      [2](/tags/broken-link-tag-2)

      ## Anchor Link Below

      ### non-broken-link
      [Google](https://google.com)

      ### broken-link-tag-3
      [3](/tags/broken-link-tag-3)
    END
  end
  let(:article) { create(:article, content: markdown) }
  let(:article_links_service) { ArticleLinksService.new(article) }

  describe "#refresh_broken_links" do
    it "clears current links for article and builds new records" do
      article_links_service.refresh_broken_links

      expect(BrokenLink.where(article_id: article.id).size).to eq(3)
    end
  end

  describe "#find_broken_links" do
    it "parses articles to find broken links, and builds active record representations of them" do
      article_links_service.find_broken_links

      expect(BrokenLink.where(article_id: article.id).size).to eq(3)
    end
  end
end

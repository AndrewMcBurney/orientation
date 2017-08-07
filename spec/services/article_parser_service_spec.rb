# frozen_string_literal: true

require "uri"
require "rails_helper"

RSpec.describe ArticleParserService do
  let(:valid_link) { "[root_url](/)" }
  let(:invalid_link) { "[broken](/tags/broken-link)" }

  let(:full_document) do
    <<~END
      # Full Markdown Document Sample

      ## Valid link
      #{valid_link}

      ## Invalid link
      #{invalid_link}
    END
  end
  let(:article_parser) { ArticleParserService.new({}, full_document) }

  let(:mock_uri_valid)   { double("uri", host: "test.com", port: "80", uri: "/", absolute?: false) }
  let(:mock_uri_invalid) { double("uri", host: "test.com", port: "80", uri: "/tags/broken-link") }

  describe "#article_link_status" do
    context "article found" do
      before do
        allow_any_instance_of(ArticleParserService)
          .to(receive(:valid_article?)
          .and_return(true))
      end

      it "returns no class" do
        status = article_parser.article_link_status(valid_link)
        expect(status).to eq(nil)
      end
    end

    context "article not found" do
      before do
        allow_any_instance_of(ArticleParserService)
          .to(receive(:valid_article?)
          .and_return(false))
      end

      it "returns 'article-not-found' class" do
        status = article_parser.article_link_status(invalid_link)
        expect(status).to eq("article-not-found")
      end
    end
  end

  describe "#internal_link?" do
    it "returns true for internal links" do
      allow_any_instance_of(ArticleParserService)
        .to(receive(:safe_url_parser)
        .with(valid_link)
        .and_return(mock_uri_valid))

      response = article_parser.internal_link?(valid_link)
      expect(response).to eq(true)
    end
  end

  describe "#valid_article?" do
    it "returns false for internal links which are not articles" do
      allow_any_instance_of(ArticleParserService)
        .to(receive(:safe_url_parser)
        .with(valid_link)
        .and_return(mock_uri_valid))

      response = article_parser.valid_article?(valid_link)
      expect(response).to eq(false)
    end
  end
end

require "rails_helper"

RSpec.describe "Updating an article" do
  let(:article) { create(:article) }
  before { visit edit_article_path(article) }

  context "with valid parameters" do
    before do
      fill_in "article_title", with: "mexican food"
      fill_in "article_content", with: "sounds good right now"
      click_button "Update Article"
    end

    it "does not render the edit article page" do
      expect(current_path).to_not eq(edit_article_path(article))
      expect(page).to have_content 'Article was successfully updated.'
    end
  end
end

require "rails_helper"

RSpec.describe 'deleting an author' do
  let!(:logged_in_user) { create(:user) }
  let(:author) { create(:user) }

  it "should redirect to authors index" do
    visit author_path(author.id)

    expect do
      click_link_or_button 'Delete Author'
      expect(current_path).to eq(authors_path)
    end.to change { User.where(id: author.id).count }.from(1).to(0)
  end

  it "should not delete itself" do
    visit author_path(logged_in_user.id)

    expect do
      click_link_or_button 'Delete Author'
    end.to raise_error(Capybara::ElementNotFound)
  end

  context 'author with articles, edits and rot reports' do
    let(:article) { create(:article, author: author) }
    let(:edit) { create(:article, editor: author) }
    let(:rot_report) { create(:article, rot_reporter: author) }

    it "should re-assign the author to be logged in user" do
      visit author_path(author.id)

      expect do
        expect do
          expect do
            click_link_or_button 'Delete Author'
            expect(current_path).to eq(authors_path)
          end.to change { article.reload.author }.from(author).to(logged_in_user)
        end.to change { edit.reload.editor }.from(author).to(logged_in_user)
      end.to change { rot_report.reload.rot_reporter }.from(author).to(logged_in_user)
    end
  end
end

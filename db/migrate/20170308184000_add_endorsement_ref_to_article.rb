class AddEndorsementRefToArticle < ActiveRecord::Migration[5.0]
  def change
  	add_foreign_key :article_endorsements, :articles
  end
end

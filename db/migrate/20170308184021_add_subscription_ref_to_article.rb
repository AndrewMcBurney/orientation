class AddSubscriptionRefToArticle < ActiveRecord::Migration[5.0]
  def change
  	add_foreign_key :article_subscriptions, :articles
  end
end

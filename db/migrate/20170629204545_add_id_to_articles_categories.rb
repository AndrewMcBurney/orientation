class AddIdToArticlesCategories < ActiveRecord::Migration[5.0]
  def change
    add_column :articles_categories, :id, :primary_key
  end
end

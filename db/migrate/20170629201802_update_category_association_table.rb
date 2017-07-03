class UpdateCategoryAssociationTable < ActiveRecord::Migration[5.0]
  def change
    drop_table :category_guide_associations

    create_table :articles_categories, id: false do |t|
      t.references :article
      t.references :category
    end

    add_index :articles_categories, [:article_id, :category_id]
  end
end

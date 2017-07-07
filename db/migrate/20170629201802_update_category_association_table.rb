class UpdateCategoryAssociationTable < ActiveRecord::Migration[5.0]
  def up
    drop_table :category_guide_associations

    create_table :articles_categories, id: false do |t|
      t.references :article
      t.references :category
    end

    add_index :articles_categories, [:article_id, :category_id]
  end

  def down
    drop_table :articles_categories

    create_table :category_guide_associations do |t|
      t.integer :category_id
      t.integer :article_id

      t.timestamps
    end
  end
end

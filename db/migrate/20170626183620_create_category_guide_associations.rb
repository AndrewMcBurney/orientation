class CreateCategoryGuideAssociations < ActiveRecord::Migration[5.0]
  def change
    create_table :category_guide_associations do |t|
      t.integer :category_id
      t.integer :guide_id

      t.timestamps
    end
  end
end

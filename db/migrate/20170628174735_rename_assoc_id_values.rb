class RenameAssocIdValues < ActiveRecord::Migration[5.0]
  def change
    rename_column :category_guide_associations, :guide_id, :article_id
  end
end

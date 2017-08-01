class RemoveGuideBoolean < ActiveRecord::Migration[5.0]
  def change
    remove_column :articles, :guide, :boolean
  end
end

class AddOrderColumnToCategories < ActiveRecord::Migration[5.0]
  def change
    add_column :categories, :order, :integer, null: false, default: 0
  end
end

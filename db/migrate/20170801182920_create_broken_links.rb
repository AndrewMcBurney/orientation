# frozen_string_literal: true

class CreateBrokenLinks < ActiveRecord::Migration[5.0]
  def change
    create_table :broken_links do |t|
      t.integer :article_id
      t.integer :author_id
      t.string :url, null: false

      t.timestamps
    end

    add_index :broken_links, :article_id
  end
end

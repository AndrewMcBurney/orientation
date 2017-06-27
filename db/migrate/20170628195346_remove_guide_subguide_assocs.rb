class RemoveGuideSubguideAssocs < ActiveRecord::Migration[5.0]
  def change
    drop_table :guide_subguide_assocs
  end
end

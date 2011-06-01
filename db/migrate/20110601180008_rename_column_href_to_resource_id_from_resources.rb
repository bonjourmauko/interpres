class RenameColumnHrefToResourceIdFromResources < ActiveRecord::Migration
  def self.up
    rename_column :resources, :href, :resources_id
  end

  def self.down
    rename_column :resources, :resources_id, :href
  end
end

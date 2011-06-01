class RenameColumnHrefToResourceIdFromResourcesAgain < ActiveRecord::Migration
  def self.up
    rename_column :resources, :resources_id, :resource_id
  end

  def self.down
    rename_column :resources, :resource_id, :resources_id
  end
end

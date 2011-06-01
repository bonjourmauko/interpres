class RenameTableEmailsToResources < ActiveRecord::Migration
  def self.up
    rename_table :emails, :resources
  end

  def self.down
    rename_table :resources, :emails
  end
end

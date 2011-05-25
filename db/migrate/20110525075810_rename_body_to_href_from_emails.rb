class RenameBodyToHrefFromEmails < ActiveRecord::Migration
  def self.up
    rename_column :emails, :body, :href
  end

  def self.down
    rename_column :emails, :href, :body
  end
end

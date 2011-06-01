class RemoveFromFromEmails < ActiveRecord::Migration
  def self.up
    remove_column :emails, :from
  end

  def self.down
    add_column :emails, :from, :string
  end
end

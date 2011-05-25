class CreateEmails < ActiveRecord::Migration
  def self.up
    create_table :emails do |t|
      t.string :body
    end
    
    add_index :emails, :body
  end

  def self.down
    drop_table :emails
  end
end

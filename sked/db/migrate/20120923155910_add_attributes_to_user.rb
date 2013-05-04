class AddAttributesToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :email, :string
    add_column :users, :identifier_url, :string
    add_index :users, :identifier_url, :unique => true
  end
  
  def self.down
    remove_column :users, :first_name
    remove_column :users, :last_name
    remove_column :users, :email
    remove_index :users, :identifier_url
    remove_column :users, :identifier_url    
  end
end

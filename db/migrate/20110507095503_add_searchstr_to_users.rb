class AddSearchstrToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :search_str, :string
  end

  def self.down
    remove_column :users, :search_str
  end
end

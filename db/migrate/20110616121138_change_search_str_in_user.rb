class ChangeSearchStrInUser < ActiveRecord::Migration
  def self.up
    change_column :users, :search_str, :text
  end

  def self.down
    change_column :users, :search_str, :string
  end
end

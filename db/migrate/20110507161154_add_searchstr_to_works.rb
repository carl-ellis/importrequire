class AddSearchstrToWorks < ActiveRecord::Migration
  def self.up
    add_column :works, :search_str, :string
  end

  def self.down
    remove_column :works, :search_str
  end
end

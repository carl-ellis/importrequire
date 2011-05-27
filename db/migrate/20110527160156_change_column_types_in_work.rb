class ChangeColumnTypesInWork < ActiveRecord::Migration
  def self.up
		change_column :works, :name, :text
		change_column :works, :url, :text
		change_column :works, :description, :text
  end

  def self.down
		change_column :works, :name, :string
		change_column :works, :url, :string
		change_column :works, :description, :string
  end
end

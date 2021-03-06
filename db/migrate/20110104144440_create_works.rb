class CreateWorks < ActiveRecord::Migration
  def self.up
    create_table :works do |t|
      t.string :name
      t.string :description
      t.string :url

      t.timestamps
    end
  end

  def self.down
    drop_table :works
  end
end

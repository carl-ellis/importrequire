class AddRatingToWorks < ActiveRecord::Migration
  def self.up
    add_column :works, :rating, :float
  end

  def self.down
    remove_column :works, :rating
  end
end

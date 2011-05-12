class CreateRatings < ActiveRecord::Migration
  def self.up
    create_table :ratings do |t|
      t.integer :work_id
      t.integer :user_id
      t.float :weight
      t.integer :score

      t.timestamps
    end
  end

  def self.down
    drop_table :ratings
  end
end

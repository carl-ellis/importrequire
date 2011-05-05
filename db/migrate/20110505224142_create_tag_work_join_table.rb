class CreateTagWorkJoinTable < ActiveRecord::Migration
  def self.up
		create_table :tags_works, :id => false do |t|
			t.integer :work_id
			t.integer :tag_id
		end
  end

  def self.down
		drop_table :tags_works
  end
end

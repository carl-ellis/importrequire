class CreateUserWorkJoinTable < ActiveRecord::Migration
  def self.up
		create_table :users_works, :id => false do |t|
			t.integer :user_id
			t.integer :work_id
		end
  end

  def self.down
		drop_table :users_works
  end
end

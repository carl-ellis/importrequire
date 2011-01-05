class CreateAffiliationUserJoinTable < ActiveRecord::Migration
  def self.up
		create_table :affiliations_users, :id => false do |t|
			t.integer :affiliation_id
			t.integer :user_id
		end
  end

  def self.down
		drop_table :affiliations_users
  end
end

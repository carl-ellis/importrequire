class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :name
      t.string :handle
      t.string :email
      t.boolean :showname
      t.boolean :showemail
      t.boolean :notify
      t.string :passhash

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end

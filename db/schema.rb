# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110507161154) do

  create_table "affiliations", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "affiliations_users", :id => false, :force => true do |t|
    t.integer "affiliation_id"
    t.integer "user_id"
  end

  create_table "tags", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tags_users", :id => false, :force => true do |t|
    t.integer "tag_id"
    t.integer "user_id"
  end

  create_table "tags_works", :id => false, :force => true do |t|
    t.integer "work_id"
    t.integer "tag_id"
  end

  create_table "types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "handle"
    t.string   "email"
    t.boolean  "showname"
    t.boolean  "showemail"
    t.boolean  "notify"
    t.string   "passhash"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "salt"
    t.string   "search_str"
  end

  create_table "users_works", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "work_id"
  end

  create_table "works", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "search_str"
  end

end

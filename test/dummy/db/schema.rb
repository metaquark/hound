# encoding: UTF-8
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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20130314120938) do

  create_table "articles", force: true do |t|
    t.string   "title"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "hound_actions", force: true do |t|
    t.string   "action",          null: false
    t.string   "actionable_type", null: false
    t.integer  "actionable_id",   null: false
    t.integer  "user_id"
    t.string   "user_type"
    t.datetime "created_at"
    t.text     "changeset"
  end

  add_index "hound_actions", ["actionable_type", "actionable_id"], name: "index_hound_actions_on_actionable_type_and_actionable_id"
  add_index "hound_actions", ["user_type", "user_id"], name: "index_hound_actions_on_user_type_and_user_id"

  create_table "posts", force: true do |t|
    t.text     "text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end

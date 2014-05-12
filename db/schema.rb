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

ActiveRecord::Schema.define(version: 20140227210609) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "articles", force: true do |t|
    t.text     "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "follows", force: true do |t|
    t.integer  "followable_id",                   null: false
    t.string   "followable_type",                 null: false
    t.integer  "follower_id",                     null: false
    t.string   "follower_type",                   null: false
    t.boolean  "blocked",         default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "follows", ["followable_id", "followable_type"], name: "fk_followables", using: :btree
  add_index "follows", ["follower_id", "follower_type"], name: "fk_follows", using: :btree

  create_table "gifs", force: true do |t|
    t.text     "title"
    t.text     "description",        default: "",          null: false
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.text     "uid"
    t.text     "url"
    t.text     "sprite"
    t.integer  "start_frame",        default: 0
    t.integer  "end_frame"
    t.integer  "fps",                default: 0
    t.text     "loop_style",         default: "beginning"
    t.boolean  "private",            default: true
  end

  add_index "gifs", ["uid"], name: "index_gifs_on_uid", unique: true, using: :btree
  add_index "gifs", ["user_id"], name: "index_gifs_on_user_id", using: :btree

  create_table "gifs_tags", force: true do |t|
    t.integer "gif_id"
    t.integer "tag_id"
  end

  add_index "gifs_tags", ["gif_id"], name: "index_gifs_tags_on_gif_id", using: :btree
  add_index "gifs_tags", ["tag_id"], name: "index_gifs_tags_on_tag_id", using: :btree

  create_table "tags", force: true do |t|
    t.text     "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "users", force: true do |t|
    t.text     "screenname"
    t.text     "name"
    t.text     "provider"
    t.text     "uid"
    t.text     "url"
    t.text     "avatar"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin",      default: false
  end

  add_index "users", ["provider"], name: "index_users_on_provider", using: :btree
  add_index "users", ["screenname"], name: "index_users_on_screenname", using: :btree

  create_table "versions", force: true do |t|
    t.text     "text"
    t.integer  "article_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "unique_hash"
    t.string   "title"
  end

end

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

ActiveRecord::Schema.define(version: 2022_01_07_165806) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "users", force: :cascade do |t|
    t.string "slack_id"
    t.string "display_name"
    t.string "actual_name"
    t.boolean "is_group"
    t.boolean "is_deleted", default: false
    t.string "team_id"
    t.index ["slack_id"], name: "index_users_on_slack_id", unique: true
  end

  create_table "views", force: :cascade do |t|
    t.string "view_id"
    t.string "slack_user_id"
    t.string "emoji"
    t.string "headline"
    t.text "details"
    t.text "user_selection", array: true
    t.text "value_selection", array: true
    t.boolean "posted", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "custom_values"
    t.string "image_url"
  end

end

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_01_20_150219) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string "color", default: "#6366f1"
    t.datetime "created_at", null: false
    t.text "description"
    t.string "icon", default: "star"
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_categories_on_name", unique: true
  end

  create_table "daily_activities", force: :cascade do |t|
    t.date "activity_date", null: false
    t.boolean "completed", default: false, null: false
    t.datetime "created_at", null: false
    t.text "notes"
    t.bigint "sankalp_id", null: false
    t.datetime "updated_at", null: false
    t.index ["activity_date"], name: "index_daily_activities_on_activity_date"
    t.index ["sankalp_id", "activity_date"], name: "index_daily_activities_on_sankalp_id_and_activity_date", unique: true
    t.index ["sankalp_id"], name: "index_daily_activities_on_sankalp_id"
  end

  create_table "sankalps", force: :cascade do |t|
    t.bigint "category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.text "description"
    t.date "end_date"
    t.date "start_date", null: false
    t.integer "status", default: 0, null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["category_id"], name: "index_sankalps_on_category_id"
    t.index ["deleted_at"], name: "index_sankalps_on_deleted_at"
    t.index ["status"], name: "index_sankalps_on_status"
    t.index ["user_id"], name: "index_sankalps_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "first_name", default: "", null: false
    t.string "last_name", default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.integer "role", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "daily_activities", "sankalps"
  add_foreign_key "sankalps", "categories"
  add_foreign_key "sankalps", "users"
end

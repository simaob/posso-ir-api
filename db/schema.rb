# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_03_28_120731) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"

  create_table "status_crowdsource_users", force: :cascade do |t|
    t.integer "status", null: false
    t.integer "queue"
    t.datetime "posted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "store_id"
    t.bigint "user_id"
    t.index ["created_at"], name: "index_status_crowdsource_users_on_created_at"
    t.index ["posted_at"], name: "index_status_crowdsource_users_on_posted_at"
    t.index ["store_id"], name: "index_status_crowdsource_users_on_store_id"
    t.index ["user_id"], name: "index_status_crowdsource_users_on_user_id"
  end

  create_table "status_user_commitment_users", force: :cascade do |t|
    t.integer "status", null: false
    t.datetime "posted_at", null: false
    t.datetime "start_at"
    t.integer "duration"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "store_id"
    t.bigint "user_id"
    t.index ["store_id"], name: "index_status_user_commitment_users_on_store_id"
    t.index ["user_id"], name: "index_status_user_commitment_users_on_user_id"
  end

  create_table "status_user_count_users", force: :cascade do |t|
    t.integer "status", null: false
    t.integer "queue_status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "store_id"
    t.bigint "user_id"
    t.index ["store_id"], name: "index_status_user_count_users_on_store_id"
    t.index ["user_id"], name: "index_status_user_count_users_on_user_id"
  end

  create_table "statuses", force: :cascade do |t|
    t.datetime "updated_time", null: false
    t.datetime "valid_until"
    t.float "status"
    t.integer "queue"
    t.string "type", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "store_id"
    t.float "previous_status"
    t.float "previous_queue"
    t.datetime "previous_updated_time"
    t.integer "voters"
    t.integer "previous_voters"
    t.boolean "is_official", default: false
    t.boolean "active", default: true
    t.index ["active"], name: "index_statuses_on_active"
    t.index ["store_id"], name: "index_statuses_on_store_id"
  end

  create_table "stores", force: :cascade do |t|
    t.string "name"
    t.string "group"
    t.string "street"
    t.string "city"
    t.string "district"
    t.string "country"
    t.string "zip_code"
    t.float "latitude"
    t.float "longitude"
    t.integer "capacity"
    t.text "details"
    t.integer "store_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.geometry "lonlat", limit: {:srid=>0, :type=>"st_point"}
    t.integer "state", default: 1
    t.text "reason_to_delete"
    t.index ["lonlat"], name: "index_stores_on_lonlat", using: :gist
  end

  create_table "user_stores", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "store_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["store_id"], name: "index_user_stores_on_store_id"
    t.index ["user_id"], name: "index_user_stores_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: ""
    t.string "encrypted_password", default: ""
    t.string "name"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "app_uuid"
    t.datetime "last_post"
    t.integer "role", default: 0
    t.index ["name"], name: "index_users_on_name"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "status_crowdsource_users", "stores", on_delete: :cascade
  add_foreign_key "status_crowdsource_users", "users", on_delete: :cascade
  add_foreign_key "status_user_commitment_users", "stores", on_delete: :cascade
  add_foreign_key "status_user_commitment_users", "users", on_delete: :cascade
  add_foreign_key "status_user_count_users", "stores", on_delete: :cascade
  add_foreign_key "status_user_count_users", "users", on_delete: :cascade
  add_foreign_key "statuses", "stores", on_delete: :cascade
  add_foreign_key "user_stores", "stores"
  add_foreign_key "user_stores", "users"
end

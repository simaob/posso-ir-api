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

ActiveRecord::Schema.define(version: 2020_05_26_183650) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "api_keys", force: :cascade do |t|
    t.string "access_token", null: false
    t.datetime "expires_at", null: false
    t.boolean "active", default: false
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "user_id"
    t.index ["access_token"], name: "index_api_keys_on_access_token", unique: true
    t.index ["user_id"], name: "index_api_keys_on_user_id"
  end

  create_table "beach_configurations", force: :cascade do |t|
    t.integer "category"
    t.string "beach_type"
    t.string "ground"
    t.string "restrictions"
    t.string "risk_areas"
    t.integer "average_users"
    t.boolean "guarded"
    t.boolean "first_aid_station"
    t.boolean "wc"
    t.boolean "showers"
    t.boolean "accessibility"
    t.boolean "garbage_collection"
    t.boolean "cleaning"
    t.boolean "info_panel"
    t.boolean "restaurant"
    t.boolean "parking"
    t.integer "parking_spots"
    t.date "season_start"
    t.date "season_end"
    t.integer "water_quality"
    t.string "water_quality_url"
    t.boolean "quality_flag"
    t.string "water_quality_entity"
    t.string "water_quality_contact"
    t.string "water_contact_email"
    t.string "security_entity"
    t.string "security_entity_contact"
    t.string "security_entity_email"
    t.string "health_authority"
    t.string "health_authority_contact"
    t.string "health_authority_email"
    t.string "municipality"
    t.string "municipality_contact"
    t.string "municipality_email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "store_id"
    t.boolean "beach_support"
    t.boolean "water_chair"
    t.boolean "construction"
    t.boolean "collapsing_risk"
    t.index ["average_users"], name: "index_beach_configurations_on_average_users"
    t.index ["category"], name: "index_beach_configurations_on_category"
    t.index ["guarded"], name: "index_beach_configurations_on_guarded"
    t.index ["parking"], name: "index_beach_configurations_on_parking"
    t.index ["quality_flag"], name: "index_beach_configurations_on_quality_flag"
    t.index ["store_id"], name: "index_beach_configurations_on_store_id"
    t.index ["water_quality"], name: "index_beach_configurations_on_water_quality"
  end

  create_table "phones", force: :cascade do |t|
    t.string "phone_number", null: false
    t.string "name"
    t.boolean "active", default: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "store_id"
    t.index ["phone_number"], name: "index_phones_on_phone_number", unique: true
    t.index ["store_id"], name: "index_phones_on_store_id"
  end

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

  create_table "status_estimation_histories", force: :cascade do |t|
    t.datetime "updated_time"
    t.datetime "valid_until"
    t.float "status"
    t.bigint "store_id"
    t.datetime "old_created_at"
    t.datetime "old_updated_at"
  end

  create_table "status_histories", force: :cascade do |t|
    t.datetime "updated_time"
    t.datetime "valid_until"
    t.float "status"
    t.float "queue"
    t.string "type"
    t.bigint "store_id"
    t.integer "voters"
    t.boolean "is_official"
    t.datetime "old_created_at"
    t.datetime "old_updated_at"
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
    t.boolean "estimation", default: false
    t.index ["active"], name: "index_statuses_on_active"
    t.index ["estimation"], name: "index_statuses_on_estimation"
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
    t.integer "store_type", default: 1, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.geometry "lonlat", limit: {:srid=>0, :type=>"st_point"}
    t.integer "state", default: 1
    t.text "reason_to_delete"
    t.boolean "open", default: true
    t.bigint "created_by_id"
    t.bigint "updated_by_id"
    t.boolean "from_osm", default: false
    t.bigint "original_id"
    t.string "source"
    t.boolean "make_phone_calls", default: false
    t.integer "phone_call_interval", default: 60
    t.index ["created_by_id"], name: "index_stores_on_created_by_id"
    t.index ["lonlat"], name: "index_stores_on_lonlat", using: :gist
    t.index ["make_phone_calls"], name: "index_stores_on_make_phone_calls"
    t.index ["updated_by_id"], name: "index_stores_on_updated_by_id"
  end

  create_table "user_stores", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "store_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "approved", default: false
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
    t.string "store_owner_code"
    t.index ["name"], name: "index_users_on_name"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "week_days", force: :cascade do |t|
    t.integer "day", null: false
    t.time "opening_hour"
    t.time "closing_hour"
    t.boolean "active", default: false
    t.string "timestamps"
    t.bigint "store_id"
    t.datetime "created_at", default: "2020-05-05 20:33:42", null: false
    t.datetime "updated_at", default: "2020-05-05 20:33:42", null: false
    t.index ["active"], name: "index_week_days_on_active"
    t.index ["store_id", "day"], name: "index_week_days_on_store_id_and_day", unique: true
    t.index ["store_id"], name: "index_week_days_on_store_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "api_keys", "users", on_delete: :cascade
  add_foreign_key "beach_configurations", "stores", on_delete: :cascade
  add_foreign_key "phones", "stores", on_delete: :cascade
  add_foreign_key "status_crowdsource_users", "stores", on_delete: :cascade
  add_foreign_key "status_crowdsource_users", "users", on_delete: :cascade
  add_foreign_key "status_user_commitment_users", "stores", on_delete: :cascade
  add_foreign_key "status_user_commitment_users", "users", on_delete: :cascade
  add_foreign_key "status_user_count_users", "stores", on_delete: :cascade
  add_foreign_key "status_user_count_users", "users", on_delete: :cascade
  add_foreign_key "statuses", "stores", on_delete: :cascade
  add_foreign_key "stores", "users", column: "created_by_id"
  add_foreign_key "stores", "users", column: "updated_by_id"
  add_foreign_key "user_stores", "stores"
  add_foreign_key "user_stores", "users"
  add_foreign_key "week_days", "stores", on_delete: :cascade
end

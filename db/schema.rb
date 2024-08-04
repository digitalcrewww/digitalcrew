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

ActiveRecord::Schema[7.1].define(version: 2024_08_04_094519) do
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
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "aircrafts", force: :cascade do |t|
    t.string "name", null: false
    t.string "icao_code", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["icao_code"], name: "index_aircrafts_on_icao_code", unique: true
    t.index ["name"], name: "index_aircrafts_on_name", unique: true
  end

  create_table "fleets", force: :cascade do |t|
    t.integer "aircraft_id", null: false
    t.string "livery", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["aircraft_id"], name: "index_fleets_on_aircraft_id"
  end

  create_table "fleets_routes", id: false, force: :cascade do |t|
    t.integer "route_id", null: false
    t.integer "fleet_id", null: false
    t.index ["fleet_id", "route_id"], name: "index_fleets_routes_on_fleet_id_and_route_id"
    t.index ["route_id", "fleet_id"], name: "index_fleets_routes_on_route_id_and_fleet_id", unique: true
  end

  create_table "multipliers", force: :cascade do |t|
    t.string "name", null: false
    t.float "value", default: 1.0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pireps", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "flight_number", null: false
    t.date "flight_date", null: false
    t.string "departure_icao", null: false
    t.string "arrival_icao", null: false
    t.integer "flight_time_minutes", null: false
    t.integer "fuel_used", null: false
    t.integer "cargo", null: false
    t.string "remarks", limit: 500
    t.string "status", default: "pending"
    t.integer "fleet_id", null: false
    t.integer "multiplier_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["arrival_icao"], name: "index_pireps_on_arrival_icao"
    t.index ["departure_icao"], name: "index_pireps_on_departure_icao"
    t.index ["fleet_id"], name: "index_pireps_on_fleet_id"
    t.index ["flight_number"], name: "index_pireps_on_flight_number"
    t.index ["multiplier_id"], name: "index_pireps_on_multiplier_id"
    t.index ["user_id"], name: "index_pireps_on_user_id"
  end

  create_table "routes", force: :cascade do |t|
    t.string "flight_number", null: false
    t.string "departure_icao", null: false
    t.string "arrival_icao", null: false
    t.integer "duration", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["departure_icao", "arrival_icao"], name: "index_routes_on_departure_icao_and_arrival_icao"
    t.index ["flight_number"], name: "index_routes_on_flight_number", unique: true
  end

  create_table "sessions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "session_id", null: false
    t.string "user_agent"
    t.datetime "expires_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "settings", force: :cascade do |t|
    t.string "airline_name", null: false
    t.string "callsign", null: false
    t.integer "owner_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["airline_name"], name: "index_settings_on_airline_name", unique: true
    t.index ["callsign"], name: "index_settings_on_callsign", unique: true
    t.index ["owner_id"], name: "index_settings_on_owner_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username", null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.integer "flight_time", default: 0, null: false
    t.boolean "is_accepted", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "fleets", "aircrafts"
  add_foreign_key "pireps", "fleets"
  add_foreign_key "pireps", "multipliers"
  add_foreign_key "pireps", "users"
  add_foreign_key "sessions", "users"
  add_foreign_key "settings", "users", column: "owner_id"
end

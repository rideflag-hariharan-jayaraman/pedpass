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

ActiveRecord::Schema.define(version: 20180113042457) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "beacons", force: :cascade do |t|
    t.string "beacon_id", null: false, comment: "The beacon_id is simply a short id or alias to the ibeacon_uuid. It's only four characters."
    t.integer "ibeacon_major", null: false
    t.integer "ibeacon_minor", null: false
    t.bigint "corner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "battery_life"
    t.datetime "battery_life_updated_at"
    t.bigint "ibeacon_uuid_id"
    t.string "name", limit: 100
    t.index ["beacon_id"], name: "index_beacons_on_beacon_id"
    t.index ["corner_id"], name: "index_beacons_on_corner_id"
    t.index ["ibeacon_uuid_id"], name: "index_beacons_on_ibeacon_uuid_id"
  end

  create_table "corners", force: :cascade do |t|
    t.string "location_in_intersection"
    t.decimal "latitude", precision: 10, scale: 6, null: false
    t.decimal "longitude", precision: 10, scale: 6, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "intersection_id"
    t.integer "near_limit", default: 2
    t.integer "approaching_limit", default: 4
    t.index ["intersection_id"], name: "index_corners_on_intersection_id"
    t.index ["latitude", "longitude"], name: "index_corners_on_latitude_and_longitude", unique: true
  end

  create_table "crossing_failure_reasons", force: :cascade do |t|
    t.string "description", null: false
    t.string "failure_code", null: false
    t.string "failure_reason", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "crossings", force: :cascade do |t|
    t.bigint "crosswalk_id"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "success", null: false
    t.integer "sub_user_id", default: 1, null: false
    t.integer "crossing_failure_reason_id"
    t.index ["crosswalk_id"], name: "index_crossings_on_crosswalk_id"
    t.index ["user_id", "sub_user_id"], name: "index_crossings_on_user_id_and_sub_user_id"
    t.index ["user_id"], name: "index_crossings_on_user_id"
  end

  create_table "crosswalks", force: :cascade do |t|
    t.string "location"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "detected_beacons", force: :cascade do |t|
    t.bigint "detected_corner_id"
    t.bigint "beacon_id"
    t.string "beacon_proximity", null: false
    t.decimal "beacon_distance", precision: 10, scale: 7, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "beacon_battery"
    t.index ["beacon_id"], name: "index_detected_beacons_on_beacon_id"
    t.index ["detected_corner_id"], name: "index_detected_beacons_on_detected_corner_id"
  end

  create_table "detected_corners", force: :cascade do |t|
    t.string "beacon_proximity", null: false
    t.decimal "beacon_distance", precision: 10, scale: 7, null: false
    t.decimal "latitude", precision: 10, scale: 6, null: false
    t.decimal "longitude", precision: 10, scale: 6, null: false
    t.decimal "accuracy", precision: 6, scale: 3, null: false
    t.decimal "heading", precision: 6, scale: 3, null: false
    t.decimal "speed", precision: 6, scale: 3, null: false
    t.bigint "corner_id", null: false
    t.bigint "device_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "processed", default: false
    t.integer "sub_user_id", default: 1, null: false
    t.index ["corner_id"], name: "index_detected_corners_on_corner_id"
    t.index ["device_id", "sub_user_id"], name: "index_detected_corners_on_device_id_and_sub_user_id"
    t.index ["device_id"], name: "index_detected_corners_on_device_id"
  end

  create_table "detected_nodes", force: :cascade do |t|
    t.bigint "detected_corner_id", null: false
    t.bigint "crossing_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["crossing_id"], name: "index_detected_nodes_on_crossing_id"
    t.index ["detected_corner_id"], name: "index_detected_nodes_on_detected_corner_id"
  end

  create_table "devices", force: :cascade do |t|
    t.string "uuid", null: false, comment: "An MD5 hash of the Device's UUID. This helps prevent multiple signups.\n"
    t.string "api_key", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_devices_on_user_id"
    t.index ["uuid"], name: "index_devices_on_uuid", unique: true
  end

  create_table "ibeacon_uuids", force: :cascade do |t|
    t.string "uuid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["uuid"], name: "index_ibeacon_uuids_on_uuid", unique: true
  end

  create_table "intersections", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "nodes", force: :cascade do |t|
    t.bigint "corner_id", null: false
    t.bigint "crosswalk_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["corner_id"], name: "index_nodes_on_corner_id"
    t.index ["crosswalk_id"], name: "index_nodes_on_crosswalk_id"
  end

  create_table "settings", force: :cascade do |t|
    t.string "var", null: false
    t.text "value"
    t.integer "thing_id"
    t.string "thing_type", limit: 30
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["thing_type", "thing_id", "var"], name: "index_settings_on_thing_type_and_thing_id_and_var", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "beacons", "corners"
  add_foreign_key "beacons", "ibeacon_uuids"
  add_foreign_key "corners", "intersections"
  add_foreign_key "crossings", "crosswalks", on_delete: :cascade
  add_foreign_key "crossings", "users", on_delete: :cascade
  add_foreign_key "detected_beacons", "beacons"
  add_foreign_key "detected_beacons", "detected_corners"
  add_foreign_key "detected_corners", "corners", on_delete: :cascade
  add_foreign_key "detected_corners", "devices", on_delete: :cascade
  add_foreign_key "detected_nodes", "crossings", on_delete: :cascade
  add_foreign_key "detected_nodes", "detected_corners", on_delete: :cascade
  add_foreign_key "devices", "users", on_delete: :cascade
  add_foreign_key "nodes", "corners", on_delete: :cascade
  add_foreign_key "nodes", "crosswalks", on_delete: :cascade
end

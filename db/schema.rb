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

ActiveRecord::Schema.define(version: 20130828101201) do

  create_table "apps", force: true do |t|
    t.integer  "users_id"
    t.string   "name"
    t.string   "predef_name"
    t.string   "predef_cloud_name"
    t.string   "app_defn_ids"
    t.string   "bolt_defn_ids"
    t.string   "domain_name"
    t.string   "book_type"
    t.string   "group_name"
    t.string   "cloud_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "apps", ["users_id"], name: "index_apps_on_users_id"

  create_table "apps_histories", force: true do |t|
    t.integer  "book_id"
    t.string   "book_name"
    t.string   "request_id"
    t.string   "status"
    t.string   "group_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "apps_histories", ["book_id"], name: "index_apps_histories_on_book_id"

  create_table "dashboards", force: true do |t|
    t.string   "name"
    t.string   "layout"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "dashboards", ["user_id"], name: "index_dashboards_on_user_id"

  create_table "identities", force: true do |t|
    t.integer  "users_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "identities", ["users_id"], name: "index_identities_on_users_id"

  create_table "users", force: true do |t|
    t.integer  "org_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "phone"
    t.boolean  "admin",                  default: true
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "verified_email",         default: false
    t.string   "verification_hash"
    t.string   "user_type"
    t.string   "api_token"
    t.boolean  "onboarded_api",          default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["onboarded_api"], name: "index_users_on_onboarded_api"
  add_index "users", ["org_id"], name: "index_users_on_org_id"
  add_index "users", ["remember_token"], name: "index_users_on_remember_token"

  create_table "widgets", force: true do |t|
    t.string   "name"
    t.string   "kind"
    t.string   "size"
    t.string   "source"
    t.text     "targets",      default: "--- []\n"
    t.text     "range"
    t.integer  "dashboard_id"
    t.string   "widget_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "widgets", ["dashboard_id"], name: "index_widgets_on_dashboard_id"

end

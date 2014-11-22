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

ActiveRecord::Schema.define(version: 20120319154255) do

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

end

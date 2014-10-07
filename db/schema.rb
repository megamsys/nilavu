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

ActiveRecord::Schema.define(version: 20130828100755) do

  create_table "apps", force: true do |t|
    t.integer  "users_id"
    t.string   "name",              limit: 255
    t.string   "predef_name",       limit: 255
    t.string   "predef_cloud_name", limit: 255
    t.string   "app_defn_ids",      limit: 255
    t.string   "bolt_defn_ids",     limit: 255
    t.string   "domain_name",       limit: 255
    t.string   "book_type",         limit: 255
    t.string   "group_name",        limit: 255
    t.string   "cloud_name",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "apps", ["users_id"], name: "index_apps_on_users_id"

  create_table "apps_histories", force: true do |t|
    t.integer  "book_id"
    t.string   "book_name",  limit: 255
    t.string   "request_id", limit: 255
    t.string   "status",     limit: 255
    t.string   "group_name", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "apps_histories", ["book_id"], name: "index_apps_histories_on_book_id"

  create_table "apps_items", force: true do |t|
    t.integer  "users_id"
    t.integer  "cloud_identity_id"
    t.integer  "product_id"
    t.string   "app_name",                limit: 255
    t.string   "my_url",                  limit: 255
    t.string   "federated_identity_type", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "apps_items", ["cloud_identity_id"], name: "index_apps_items_on_cloud_identity_id"
  add_index "apps_items", ["product_id"], name: "index_apps_items_on_product_id"
  add_index "apps_items", ["users_id"], name: "index_apps_items_on_users_id"

  create_table "cloud_identities", force: true do |t|
    t.string   "url",           limit: 255
    t.string   "account_name",  limit: 255
    t.string   "cloud_app_url", limit: 255
    t.integer  "users_id"
    t.string   "status",        limit: 255
    t.string   "launch_time",   limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "cloud_identities", ["users_id"], name: "index_cloud_identities_on_users_id"

  create_table "dashboards", force: true do |t|
    t.string   "name",       limit: 255
    t.string   "layout",     limit: 255
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "dashboards", ["user_id"], name: "index_dashboards_on_user_id"

  create_table "identities", force: true do |t|
    t.integer  "users_id"
    t.string   "provider",   limit: 255
    t.string   "uid",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "identities", ["users_id"], name: "index_identities_on_users_id"

  create_table "organizations", force: true do |t|
    t.string   "name",                limit: 255
    t.boolean  "active"
    t.string   "url",                 limit: 255
    t.string   "billing_street_name", limit: 255
    t.string   "billing_address1",    limit: 255
    t.string   "billing_address2",    limit: 255
    t.string   "billing_city",        limit: 255
    t.string   "billing_state",       limit: 255
    t.string   "billing_country",     limit: 255
    t.string   "logo_file_name",      limit: 255
    t.string   "logo_content_type",   limit: 255
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "products", force: true do |t|
    t.string  "name",             limit: 255
    t.string  "description",      limit: 255
    t.string  "url",              limit: 255
    t.string  "image_url",        limit: 255
    t.string  "category",         limit: 255
    t.string  "identity",         limit: 255
    t.boolean "app_bootstrap",                default: true
    t.boolean "app_provisioning"
    t.string  "rest_api",         limit: 255
    t.string  "deccanplato_url",  limit: 255
    t.boolean "market_place"
    t.boolean "cloud_sync"
  end

  create_table "users", force: true do |t|
    t.integer  "org_id"
    t.string   "first_name",             limit: 255
    t.string   "last_name",              limit: 255
    t.string   "email",                  limit: 255
    t.string   "phone",                  limit: 255
    t.boolean  "admin",                              default: true
    t.string   "password_digest",        limit: 255
    t.string   "remember_token",         limit: 255
    t.boolean  "verified_email",                     default: false
    t.string   "verification_hash",      limit: 255
    t.string   "user_type",              limit: 255
    t.string   "api_token",              limit: 255
    t.boolean  "onboarded_api",                      default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_reset_token",   limit: 255
    t.datetime "password_reset_sent_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["onboarded_api"], name: "index_users_on_onboarded_api"
  add_index "users", ["org_id"], name: "index_users_on_org_id"
  add_index "users", ["remember_token"], name: "index_users_on_remember_token"

end

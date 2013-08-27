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

ActiveRecord::Schema.define(version: 20130827143855) do

  create_table "apps_items", force: true do |t|
    t.integer  "users_id"
    t.integer  "cloud_identity_id"
    t.integer  "product_id"
    t.string   "app_name"
    t.string   "my_url"
    t.string   "federated_identity_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "apps_items", ["cloud_identity_id"], name: "index_apps_items_on_cloud_identity_id", using: :btree
  add_index "apps_items", ["product_id"], name: "index_apps_items_on_product_id", using: :btree
  add_index "apps_items", ["users_id"], name: "index_apps_items_on_users_id", using: :btree

  create_table "cloud_books", force: true do |t|
    t.integer  "users_id"
    t.string   "name"
    t.string   "predef_name"
    t.string   "predef_cloud_name"
    t.string   "deps_scm"
    t.string   "deps_war"
    t.string   "domain_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "cloud_books", ["users_id"], name: "index_cloud_books_on_users_id", using: :btree

  create_table "cloud_books_histories", force: true do |t|
    t.integer  "book_id"
    t.string   "book_name"
    t.string   "request_id"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "cloud_books_histories", ["book_id"], name: "index_cloud_books_histories_on_book_id", using: :btree

  create_table "cloud_identities", force: true do |t|
    t.string   "url"
    t.string   "account_name"
    t.string   "cloud_app_url"
    t.integer  "users_id"
    t.string   "status"
    t.string   "launch_time"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "cloud_identities", ["users_id"], name: "index_cloud_identities_on_users_id", using: :btree

  create_table "dashboards", force: true do |t|
    t.string   "name"
    t.string   "layout"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "identities", force: true do |t|
    t.integer  "users_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "identities", ["users_id"], name: "index_identities_on_users_id", using: :btree

  create_table "organizations", force: true do |t|
    t.string   "name"
    t.boolean  "active"
    t.string   "url"
    t.string   "billing_street_name"
    t.string   "billing_address1"
    t.string   "billing_address2"
    t.string   "billing_city"
    t.string   "billing_state"
    t.string   "billing_country"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
  end

  create_table "products", force: true do |t|
    t.string  "name"
    t.string  "description"
    t.string  "url"
    t.string  "image_url"
    t.string  "category"
    t.string  "identity"
    t.boolean "app_bootstrap",    default: true
    t.boolean "app_provisioning"
    t.string  "rest_api"
    t.string  "deccanplato_url"
  end

  create_table "users", force: true do |t|
    t.integer  "org_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "phone"
    t.boolean  "admin",             default: true
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "verified_email",    default: false
    t.string   "verification_hash"
    t.string   "user_type"
    t.string   "api_token"
    t.boolean  "onboarded_api",     default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["onboarded_api"], name: "index_users_on_onboarded_api", using: :btree
  add_index "users", ["org_id"], name: "index_users_on_org_id", using: :btree
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree

end

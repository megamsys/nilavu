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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120927132840) do

  create_table "apps_items", :force => true do |t|
    t.integer  "cloud_app_id"
    t.integer  "product_id"
    t.string   "my_url"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "apps_items", ["cloud_app_id"], :name => "index_apps_items_on_cloud_app_id"
  add_index "apps_items", ["product_id"], :name => "index_apps_items_on_product_id"

  create_table "cloud_apps", :force => true do |t|
    t.integer  "org_id"
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "cloud_apps", ["org_id"], :name => "index_cloud_apps_on_org_id"

  create_table "cloud_identities", :force => true do |t|
    t.string   "url"
    t.integer  "org_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "cloud_identities", ["org_id"], :name => "index_cloud_identities_on_org_id"

  create_table "connector_actions", :force => true do |t|
    t.integer  "connector_id"
    t.string   "user_name"
    t.string   "profile_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "alias"
    t.string   "time_zone",         :default => "America/Los_Angeles"
    t.string   "locale",            :default => "en_US"
    t.string   "char_set_encoding", :default => "UTF-8"
    t.string   "language",          :default => "en_US"
    t.datetime "created_at",                                           :null => false
    t.datetime "updated_at",                                           :null => false
  end

  add_index "connector_actions", ["connector_id"], :name => "index_connector_actions_on_connector_id"

  create_table "connector_outputs", :force => true do |t|
    t.string   "connector_id"
    t.string   "status"
    t.string   "message"
    t.string   "output_display"
    t.string   "log"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "connector_outputs", ["connector_id"], :name => "index_connector_outputs_on_connector_id"

  create_table "connectors", :force => true do |t|
    t.integer  "cloud_app_id"
    t.string   "salesforce_consumer_key"
    t.string   "salesforce_consumer_secret"
    t.string   "description"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  add_index "connectors", ["cloud_app_id"], :name => "index_connectors_on_cloud_app_id"

  create_table "identities", :force => true do |t|
    t.integer  "users_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "identities", ["users_id"], :name => "index_identities_on_users_id"

  create_table "organizations", :force => true do |t|
    t.string   "name"
    t.boolean  "active"
    t.string   "type"
    t.string   "account_name"
    t.string   "url"
    t.string   "billing_street_name"
    t.string   "billing_address1"
    t.string   "billing_address2"
    t.string   "billing_city"
    t.string   "billing_state"
    t.string   "billing_country"
    t.string   "api_token"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
  end

  add_index "organizations", ["account_name"], :name => "index_organizations_on_account_name"

  create_table "products", :force => true do |t|
    t.string "name"
    t.string "description"
    t.string "url"
    t.string "image_url"
    t.string "category"
  end

  create_table "users", :force => true do |t|
    t.integer  "org_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "phone"
    t.boolean  "admin",             :default => true
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "verified_email",    :default => false
    t.string   "verification_hash"
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["org_id"], :name => "index_users_on_org_id"
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

end

class Product < ActiveRecord::Base
  attr_accessible :description, :name, :url, :image_url, :category, :identity, :app_bootstrap, :app_provisioning, :rest_api, :deccanplato_url, :market_place, :cloud_sync
  has_many :apps_items
end

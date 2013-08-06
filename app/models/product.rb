class Product < ActiveRecord::Base
  attr_accessible :description, :name, :url, :image_url, :category, :identity, :app_bootstrap, :app_provisioning, :rest_api, :deccanplato_url
  has_many :apps_items
end

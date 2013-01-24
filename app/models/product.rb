class Product < ActiveRecord::Base
  attr_accessible :description, :name, :url, :image_url, :category, :identity, :app_bootstrap, :app_provisioning
  has_many :apps_items
end

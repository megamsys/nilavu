class Product < ActiveRecord::Base
  attr_accessible :description, :name, :url, :image_url, :category, :identity
  has_many :apps_items
end

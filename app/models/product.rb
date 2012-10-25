class Product < ActiveRecord::Base
  attr_accessible :description, :name, :url, :image_url, :category
  has_many :apps_items
end

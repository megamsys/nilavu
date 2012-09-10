class Product < ActiveRecord::Base
  attr_accessible :description, :name, :url, :image_url
  has_many :apps_items
end

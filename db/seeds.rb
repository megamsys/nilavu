# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Product.delete_all

open("config/products_seed.data") do |products|
  products.read.each_line do |product|
    name, description, url, image_url = product.chomp.split("|")
    Product.create!(:name => name, :description => description, :url => url, :image_url => image_url)
  end
end

#Fixtures.create_fixtures("#{Rails.root}/test/fixtures", "product")
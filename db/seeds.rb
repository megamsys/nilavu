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
    name, description, url, image_url, category = product.chomp.split("|")
    Product.create!(:name => name, :description => description, :url => url, :image_url => image_url, :category => category)
  end
end
puts "Delete ConnectorOutput"
@co = ConnectorOutput.all
@co.each do |co| 
  co.delete()
end

@ca = ConnectorAction.all
@ca.each do |ca| 
  ca.delete()
end
@cp = ConnectorProject.all
@cp.each do |cp| 
  cp.delete()
end

@ce = ConnectorExecution.all
@ce.each do |ce| 
  ce.delete()
end


cp = ConnectorProject.create_table
ca = ConnectorAction.create_table
co = ConnectorOutput.create_table
ce = ConnectorExecution.create_table

#Fixtures.create_fixtures("#{Rails.root}/test/fixtures", "product")

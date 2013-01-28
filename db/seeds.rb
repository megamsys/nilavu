# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Product.delete_all

puts "Load Products"
open("config/products_seed.data") do |products|
  products.read.each_line do |product|
    name, description, url, image_url, category, identity, app_provisioning = product.chomp.split("|")
    Product.create!(:name => name, :description => description, :url => url, :image_url => image_url, :category => category, :identity => identity, :app_provisioning => app_provisioning)
  end
end

puts ""
puts "DynamoDB Deletion"


@ce = ConnectorExecution.all
@ce.each do |ce| 
  ce.delete()
end
puts "ConnectorExecution Deleted"

@co = ConnectorOutput.all
@co.each do |co| 
  co.delete()
end
puts "ConnectorOutput Deleted"

@ca = ConnectorAction.all
@ca.each do |ca| 
  ca.delete()
end
puts "ConnectorAction Deleted"

@cp = ConnectorProject.all
@cp.each do |cp| 
  cp.delete()
end
puts "ConnectorProject Deleted"



puts ""
puts "DynamoDB Creation"


cp = ConnectorProject.create_table
puts "ConnectorProject Created"
ca = ConnectorAction.create_table
puts "ConnectorAction Created"
co = ConnectorOutput.create_table
puts "ConnectorOutput Created"
ce = ConnectorExecution.create_table
puts "ConnectorExecution Created"

#Fixtures.create_fixtures("#{Rails.root}/test/fixtures", "product")

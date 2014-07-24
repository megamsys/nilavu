# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Product.delete_all
User.where(:email => "fake@mypaas.io").delete_all

puts "== Products: loading"
open("config/products_seed.data") do |products|
  products.read.each_line do |product|
    name, description, url, image_url, category, identity, app_provisioning, rest_api, deccanplato_url, market_place, cloud_sync = product.chomp.split("|")
    Product.create!(:name => name, :description => description, :url => url, :image_url => image_url, :category => category, :identity => identity, :app_provisioning => app_provisioning, :rest_api => rest_api, :deccanplato_url => deccanplato_url, :market_place => market_place, :cloud_sync => cloud_sync)
  end
end
puts "== Products: loaded"
puts "== Users: dummy user"
dummyparams = {:email => "fake@mypaas.io", :password => "fakemypaas#megam", :password_confirmation => "fakemypaas#megam", :first_name => "Demo user",:last_name => "View only",:api_token =>"fakemypaas#megam", :onboarded_api => true, :admin => false, :user_type =>"demo"}
dummyuser = User.new(dummyparams)
dummyuser.save
puts "== Users: dummy user created."

=begin
puts "NOTICE: fake_dynamo[rvmsudo fake_dynamo --port 4567] should be running."
puts "==  DynamoDB: deleting:"

# delete only if the tables exists. If you encounter an error, then move on.
begin
@ce = ConnectorExecution.all
@ce.each do |ce|
ce.delete()
end
puts "-- ConnectorExecution: deleted"
rescue => ex
puts "-- #{ex.message}"
puts "-- skip ConnectorExecution: deletion"
end

begin
@co = ConnectorOutput.all
@co.each do |co|
co.delete()
end
puts "-- ConnectorOutput   : deleted"
rescue => ex
puts "-- #{ex.message}"
puts "-- skip ConnectorOutput: deletion"
end

begin
@ca = ConnectorAction.all
@ca.each do |ca|
ca.delete()
end
puts "-- ConnectorAction   : deleted"
rescue => ex
puts "-- #{ex.message}"
puts "-- skip ConnectorAction: deletion"
end

begin
@cp = ConnectorProject.all
@cp.each do |cp|
cp.delete()
end
puts "-- ConnectorProject  : deleted"
rescue => ex
puts "-- #{ex.message}"
puts "-- skip ConnectorProject: deletion"
end

puts "==  DynamoDB: deleted"
puts "==  DynamoDB: creating"

cp = ConnectorProject.create_table
puts "-- ConnectorProject   : created"
ca = ConnectorAction.create_table
puts "-- ConnectorAction    : created"
co = ConnectorOutput.create_table
puts "-- ConnectorOutput    : created"
ce = ConnectorExecution.create_table
puts "-- ConnectorExecution : created"
puts "==  DynamoDB: created"
=end

#Fixtures.create_fixtures("#{Rails.root}/test/fixtures", "product")

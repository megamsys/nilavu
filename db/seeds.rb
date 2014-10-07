# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.where(:email => "fake@mypaas.io").delete_all
puts "== Users: fake@mypaas.io user"
dummyparams = {:email => "fake@mypaas.io", :password => "fakemypaas#megam", :password_confirmation => "fakemypaas#megam", :first_name => "Demo user",:last_name => "View only",:api_token =>"fakemypaas#megam", :onboarded_api => true, :admin => false, :user_type =>"demo"}
dummyuser = User.new(dummyparams)
dummyuser.save
puts "== Users: fake@mypaas.io user created."

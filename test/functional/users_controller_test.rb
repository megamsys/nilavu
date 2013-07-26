require 'test_helper'

class UsersControllerTest < ActionController::TestCase

#The below email shouln't be in development database
@@sample_user = {"first_name" => "Megam", "last_name" => "Systems", "phone" => "9789345999", "email" => "megam1@megam.co.in", "password" => "password", "password_i" => "drowssap"}

test "Sign up with all input parameters" do
  assert_difference('User.count') do
  post :create, user: {:first_name => @@sample_user["first_name"], :last_name => @@sample_user["last_name"], :phone => @@sample_user["phone"], :email => @@sample_user["email"], :password => @@sample_user["password"], :password_confirmation => @@sample_user["password"]}
  end
  assert_redirected_to users_dashboard_url
  assert_equal flash[:success] , "Welcome #{@@sample_user["first_name"]}"
end

test "Sign up without optional input parameters" do
  assert_difference('User.count') do
  post :create, user: {:first_name => @@sample_user["first_name"], :email => @@sample_user["email"], :password => @@sample_user["password"], :password_confirmation => @@sample_user["password"]}
  end
  assert_redirected_to users_dashboard_url
  assert_equal flash[:success] , "Welcome #{@@sample_user["first_name"]}"
end

test "Sign up with defferent values of password & password confirmations" do
  assert_difference('User.count') do
  post :create, user: {:first_name => @@sample_user["first_name"], :last_name => @@sample_user["last_name"], :phone => @@sample_user["phone"], :email => @@sample_user["email"], :password => @@sample_user["password"], :password_confirmation => @@sample_user["password_i"]}
  end
  assert_redirected_to users_dashboard_url
  assert_equal flash[:success] , "Welcome #{@@sample_user["first_name"]}"
end



end

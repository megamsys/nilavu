##
## Copyright [2013-2015] [Megam Systems]
##
## Licensed under the Apache License, Version 2.0 (the "License");
## you may not use this file except in compliance with the License.
## You may obtain a copy of the License at
##
## http://www.apache.org/licenses/LICENSE-2.0
##
## Unless required by applicable law or agreed to in writing, software
## distributed under the License is distributed on an "AS IS" BASIS,
## WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
## See the License for the specific language governing permissions and
## limitations under the License.
##
require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  #The below email shouln't be in development database
  @@sample_user = {"first_name" => "Megam", "last_name" => "Systems", "phone" => "9789345999", "email" => "megam1@megam.co.in", "password" => "password", "password_i" => "drowssap"}

  test "Sign up with all input parameters" do
    assert_difference('User.count') do
      post :create, user: {:first_name => @@sample_user["first_name"], :last_name => @@sample_user["last_name"], :phone => @@sample_user["phone"], :email => @@sample_user["email"], :password => @@sample_user["password"], :password_confirmation => @@sample_user["password"]}
    end
    assert_redirected_to dashboards_path
    assert_equal flash[:success] , "Welcome #{@@sample_user["first_name"]}"
  end

  test "Sign up without optional input parameters" do
    assert_difference('User.count') do
      post :create, user: {:first_name => @@sample_user["first_name"], :email => @@sample_user["email"], :password => @@sample_user["password"], :password_confirmation => @@sample_user["password"]}
    end
    assert_redirected_to dashboards_path
    assert_equal flash[:success] , "Welcome #{@@sample_user["first_name"]}"
  end

  test "Sign up with defferent values of password & password confirmations" do
     post :create, user: {:first_name => @@sample_user["first_name"], :last_name => @@sample_user["last_name"], :phone => @@sample_user["phone"], :email => @@sample_user["email"], :password => @@sample_user["password"], :password_confirmation => @@sample_user["password_i"]}
     assert_redirected_to signup_path
    #assert_equal flash[:success] , "Welcome #{@@sample_user["first_name"]}"
  end

end

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

class UserTest < ActiveSupport::TestCase
fixtures :users
def test_users_true
	#puts users(:alrin).inspect
	#User.new(users(:alrin))
	users :create, params: users(:alrin)
	signup_path(users(:alrin).email)
	puts "success"
	#signin users(:alrin)
	#assert true
end
end

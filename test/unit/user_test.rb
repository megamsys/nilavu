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

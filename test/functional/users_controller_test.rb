require 'test_helper'

class UsersControllerTest < ActionController::TestCase
fixtures :users
  test "should get new" do
    get :new
    assert_response :success
  end

test "new should render correct partial" do
  get :new
  assert_template layout: "layouts/application", partial: "_create_form"
  assert_response :success
end

test "should create post" do
u = users(:alrin)
  assert_difference('User.count') do
    post :create, user: {:first_name => "ALRin", :email => "thomas@megam.co.in", :last_name => "Tom", :phone => "9789345999", :password => "password"}
  end
  assert_redirected_to post_path(assigns(:post))
  assert_equal 'Post was successfully created.', flash[:notice]
end

end

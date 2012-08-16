describe UsersController, "creating a new user" do
  integrate_views
  fixtures :users
  
  it "should redirect to index with a notice on successful save" do
    Users.any_instance.stubs(:valid?).returns(true)
    post 'create'
    assigns[:user].should_not be_new_record
    flash[:notice].should_not be_nil
    response.should redirect_to(users_path)
  end

  
end

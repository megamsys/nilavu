require "spec_helper"

describe UserMailer do
  include Rails.application.routes.url_helpers
###convert it to your own need.

  before(:all) do
    @user = create(:user)
    @email = UserMailer.confirmation_email(@user)
  end

  it "should be sent to the user email" do
    @email.should deliver_to(@user.email)
  end

  it "should contain the activation link inside" do
    pending("Uncomment after activation function works")
    # @email.should have_body_text(/#{activate_path(:code => @user.activation_code)}/)
  end

end

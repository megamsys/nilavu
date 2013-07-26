require 'spec_helper'

describe "User pages" do

 describe "signup" do

    before { visit signup_path }

    let(:submit) { "Create User" }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end
    end

    describe "with valid information" do
      before do
        fill_in "first_name",         with: "Example User"
        fill_in "email",        with: "user@example.com"
        fill_in "password",     with: "foobar"
        fill_in "password_confirmation", with: "foobar"
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end
    end
  end
end

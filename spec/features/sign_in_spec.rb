require "rails_helper"

RSpec.feature "Users can signin", :type => :feature do
  #let!(:user) { FactoryGirl.create(:user) }
  user = FactoryGirl.create(:user)

  scenario "with valid attributes" do
    visit "/signin"
    fill_in "Email", :with => user.email
    fill_in "password", :with => "speed"
    click_button "Login"

    expect(page).to have_content "Dashboard"
  end
end

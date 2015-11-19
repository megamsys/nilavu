require "rails_helper"

RSpec.feature "Users can signin", :type => :feature do
  #let!(:accounts) { FactoryGirl.create(:accounts) }
  #usr = FactoryGirl.create(:accounts)

  scenario "with valid attributes" do
    visit "/signin"
    fill_in "Email", :with => "test@three.com"
    fill_in "password", :with => "speed"
    click_button "Login"

    expect(page).to have_content "Dashboard"
  end
end

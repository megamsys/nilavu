require "rails_helper"

RSpec.feature "Users can signin" do
  let!(:Test) { FactoryGirl.create(:Test) }

  scenario "with valid attributes" do
    visit "/signin"
    fill_in "Email", :with => Test.email
    fill_in "password", :with => "speed"
    click_button "Login"

    expect(page).to have_content "Dashboard"
  end
end

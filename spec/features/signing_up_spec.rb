require "rails_helper"

RSpec.feature "Users can signup", :type => :feature do
  
  scenario "when providing valid details" do
    visit "/signup"
    fill_in "Email", :with => "test@three.com"
    fill_in "password", :with => "speed"
    click_button "Sign up"

    expect(page).to have_content "Dashboard"
  end

  scenario "when providing duplicate email" do
    visit "/signup"
    fill_in "Email", :with => "test@three.com"
    fill_in "password", :with => "speed"
    click_button "Sign up"

    expect(page).to have_content "Au!Oh"
  end

end

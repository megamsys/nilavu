require "rails_helper"

RSpec.features "Users can signup" do
  scenario "with valid attributes" do
    visit "/"

    click_link "Signup"
    fill_in "Name", with: "dumname"
    click_button "Create"

    expect(page).to_have_content "User created"
    
  end
end

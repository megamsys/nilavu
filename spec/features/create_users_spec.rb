require "rails_helper"

RSpec.feature "Users can signup" do
  scenario "with valid attributes" do
    visit "/signin"

    click_link "Create new account ?"
    fill_in "Email", :with => "megam1@nilavu.com"
    fill_in  "Password", :with => "megam"
    click_button "Create"

    expect(page).to have_content "User created"
  end

  scenario "with invalid attributes" do
    visit "/signin"

    click_link "Create new account ?"
    fill_in "Email", :with => "megam"
    fill_in "Password", :with => "megam"
    click_button "Create"

    expect(page).to have_content "Please Enter valid user fields"
  end
end

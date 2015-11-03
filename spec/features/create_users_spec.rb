require "rails_helper"

RSpec.feature "Users can signup" do
  scenario "with valid attributes" do
    visit "/signin"

    click_link "Create new account ?"
    fill_in "Email", :with => "mega1@nilavu.com"
    fill_in  "Password", :with => "megam"
    click_button "Create"

    expect(page).to have_content "Dashboard"
  end

  scenario "with invalid attributes" do
    visit "/signin"

    click_link "Create new account ?"
    fill_in "Email", :with => " "
    fill_in "Password", :with => " "
    click_button "Create"

    expect(page).to have_content "Sorry!Please type a valid email address"
  end

  scenario "with existing attributes" do
    visit "/signin"

    click_link "Create new account ?"
    fill_in "Email", :with => "megam8@nilavu.com"
    fill_in  "Password", :with => "megam"
    click_button "Create"

    expect(page).to have_content "Login"
  end
end

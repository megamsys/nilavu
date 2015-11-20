require "rails_helper"

RSpec.feature "Users can signin" do
  scenario "when providing valid credentials" do
    visit "/signin"

    click_link "Create new account ?"
    fill_in "Email", :with => "test@four.com"
    fill_in "Password", :with => "megam"
    click_button "Create"

    expect(page).to have_content "Dashboard"
  end

  scenario "when email and password is missing." do
    visit "/signin"

    click_link "Create new account ?"
    fill_in "Email", :with => " "
    fill_in "Password", :with => " "
    click_button "Create"

    expect(page).to have_content "Sorry!Please type a valid email address"
  end

  scenario "when providing duplicate email - via signin" do
    visit "/signin"

    click_link "Create new account ?"
    fill_in "Email", :with => "test@four.com"
    fill_in "Password", :with => "megam"
    click_button "Create"

    expect(page).to have_content "Login"
  end
end

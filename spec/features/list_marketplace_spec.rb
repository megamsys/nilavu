require "rails_helper"

RSpec.feature "List Marketplaces" do
  before do
    visit "/signin"

    fill_in "Email", :with => "megam8@nilavu.com"
    fill_in "Password", :with => "megam"
    click_button "Login"

    expect(page).to have_content "Dashboard"
  end

  scenario "Option" do
  click_link "Marketplaces"
  click_link "Launch! Php"
  fill_in "SSH keypair name", :with => "megam"
  click_button "Create"

  expect(page).to have_content "Byoc"
  end

end

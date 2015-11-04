require "rails_helper"

RSpec.feature "List Marketplaces" do
  before do
    visit "/signin"

    fill_in "Email", :with => "megam8@nilavu.com"
    fill_in "Password", :with => "megam"
    click_button "Login"

    expect(page).to have_content "Dashboard"
  end

  scenario "view" do
    visit "/cockpits"

    click_link "Marketplaces"

    expect(page).to have_content "Marketplaces"
  end
end

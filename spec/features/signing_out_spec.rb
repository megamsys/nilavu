require "rails_helper"

RSpec.feature "Signed-in users can sign out"  do
  let!(:accounts) { FactoryGirl.create(:accounts)}

  before do
    login_as(user)
  end

  scenario do
    visit "/"
    click_link "Sign out"

    expect(page).to have_content "Have fun"
  end
end

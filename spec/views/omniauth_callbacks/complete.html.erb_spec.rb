require "rails_helper"

require "auth/authenticator"
require_dependency "auth/result"

describe "omniauth_callbacks/complete.html.erb" do

  let :rendered_data do
    returned = JSON.parse(rendered.match(/window.opener.Nilavu.authenticationComplete\((.*)\)/)[1])
  end

  it "renders auth info" do
    result = Auth::Result.new
    result.user = User.new

    assign(:auth_result, result)

    render

    expect(rendered_data["authenticated"]).to eq(false)
    expect(rendered_data["awaiting_activation"]).to eq(false)
    expect(rendered_data["awaiting_approval"]).to eq(false)
  end 

end

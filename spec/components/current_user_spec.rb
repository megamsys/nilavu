require 'rails_helper'
require_dependency 'current_user'

describe CurrentUser do
  it "allows us to lookup a user from our environment" do
    user = Fabricate(:user, api_key: '00001x', approved: true)

    env = Rack::MockRequest.env_for("/test", "HTTP_COOKIE" => "_t=#{user.api_key};")
    expect(CurrentUser.lookup_from_env(env)).to eq(user)
  end

end

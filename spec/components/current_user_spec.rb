require 'rails_helper'
require_dependency 'current_user'

describe CurrentUser do
    before do
        @user = Fabricate.build(:evil_trout)
        @user.save
    end

    it "should allow saving if email is reused" do
      env = Rack::MockRequest.env_for("/test", "HTTP_COOKIE" => "_t=#{@user.api_key}; _e=#{@user.email}; _p=imafish")
      expect(CurrentUser.lookup_from_env(env).email).to eq(@user.email)
    end

end

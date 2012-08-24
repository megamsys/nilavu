require 'spec_helper'

describe CloudAppsController do

  describe "GET 'show'" do
    it "returns http success" do
      get 'show'
      response.should be_success
    end
  end

end

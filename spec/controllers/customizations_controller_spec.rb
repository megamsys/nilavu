require 'spec_helper'

describe CustomizationsController do

  describe "GET 'refresh'" do
    it "returns http success" do
      get 'refresh'
      response.should be_success
    end
  end

end

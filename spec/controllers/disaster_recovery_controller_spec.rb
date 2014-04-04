require 'spec_helper'

describe DisasterRecoveryController do

  describe "GET 'drbd_config'" do
    it "returns http success" do
      get 'drbd_config'
      response.should be_success
    end
  end

end

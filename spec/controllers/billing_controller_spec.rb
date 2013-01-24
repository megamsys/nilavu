require 'spec_helper'

describe BillingController do

  describe "GET 'pricing'" do
    it "returns http success" do
      get 'pricing'
      response.should be_success
    end
  end

  describe "GET 'account'" do
    it "returns http success" do
      get 'account'
      response.should be_success
    end
  end

  describe "GET 'history'" do
    it "returns http success" do
      get 'history'
      response.should be_success
    end
  end

end

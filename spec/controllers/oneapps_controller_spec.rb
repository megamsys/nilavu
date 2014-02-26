require 'spec_helper'

describe OneappsController do

  describe "GET 'marketplaces'" do
    it "returns http success" do
      get 'marketplaces'
      response.should be_success
    end
  end

  describe "GET 'activities'" do
    it "returns http success" do
      get 'activities'
      response.should be_success
    end
  end

  describe "GET 'settings'" do
    it "returns http success" do
      get 'settings'
      response.should be_success
    end
  end

  describe "GET 'preclone'" do
    it "returns http success" do
      get 'preclone'
      response.should be_success
    end
  end

  describe "GET 'clone'" do
    it "returns http success" do
      get 'clone'
      response.should be_success
    end
  end

end

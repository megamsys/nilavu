require 'spec_helper'

describe ContentsController do

  describe "GET 'header'" do
    it "returns http success" do
      get 'header'
      response.should be_success
    end
  end

end

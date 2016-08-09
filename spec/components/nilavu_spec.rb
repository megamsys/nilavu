require 'rails_helper'
require 'nilavu'

describe Nilavu do

  before do
  end

  context 'base_url' do
    context 'when https is off' do
      before do
        SiteSetting.expects(:use_https?).returns(false)
      end

      it 'has a non https base url' do
        expect(Nilavu.base_url).to eq("http://localhost")
      end
    end

    context 'when https is on' do
      before do
        SiteSetting.expects(:use_https?).returns(true)
      end

      it 'has a non-ssl base url' do
        expect(Nilavu.base_url).to eq("https://localhost")
      end
    end

    context 'with a non standard port specified' do
      before do
        SiteSetting.stubs(:port).returns(3000)
      end

      it "returns the non standart port in the base url" do
        expect(Nilavu.base_url).to eq("http://localhost")
      end
    end
  end  
end

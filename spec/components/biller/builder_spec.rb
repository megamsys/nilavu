require 'rails_helper'


load 'biller/whmcs_registrar.rb'
load 'biller/whmcs_subscriber.rb'
load 'biller/whmcs_shopper.rb'
load 'biller/orderer.rb'
load 'biller/builder.rb'
load 'biller/subscriber.rb'
load 'biller/shopper.rb'
load 'biller/whmcs_orderer.rb'

describe Biller::Builder do

  context 'after initialize with WHMCS' do
    before do
        SiteSetting.stubs(:allow_billings).returns(true)
        SiteSetting.stubs(:enabled_biller).returns('WHMCS')
    end

    it 'can create a proper subscriber' do
      bildr = Biller::Builder.new("Subscriber")

      expect(bildr.implementation).to be_present

      expect(bildr.implementation.new.respond_to?(:subscribe)).to eq(true)
    end

    it 'can create a proper shopper' do
      bildr = Biller::Builder.new("Shopper")

      expect(bildr.implementation).to be_present

      expect(bildr.implementation.new.respond_to?(:shop)).to eq(true)
    end

    it 'can create a proper orderer' do
      bildr = Biller::Builder.new("Orderer")

      expect(bildr.implementation).to be_present

      expect(bildr.implementation.new.respond_to?(:order)).to eq(true)
    end

    it 'fail with invalid subscriber' do
      bildr = Biller::Builder.new("Subscribeer1")

      expect(bildr.implementation).not_to be_present
    end
  end


  context 'after initialize with Blesta' do

    before do
        SiteSetting.stubs(:allow_billings).returns(true)
        SiteSetting.stubs(:enabled_biller).returns('Blesta')
    end


    it 'fail to load subscriber' do
      bildr = Biller::Builder.new("Subscriber")

      expect(bildr.implementation).not_to be_present
    end
  end
end

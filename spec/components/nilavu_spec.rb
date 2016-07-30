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
        expect(Nilavu.base_url).to eq("http://localhost:3000")
      end
    end
  end


  context "#handle_exception" do

    it "should not fail when called" do
      exception = StandardError.new

      Nilavu.handle_job_exception(exception, nil, nil)
      expect(logger.exception).to eq(exception)
      expect(logger.context.keys).to eq([:current_db, :current_hostname])
    end

    it "correctly passes extra context" do
      exception = StandardError.new

      Nilavu.handle_job_exception(exception, {message: "Doing a test", post_id: 31}, nil)
      expect(logger.exception).to eq(exception)
      expect(logger.context.keys.sort).to eq([:current_db, :current_hostname, :message, :post_id].sort)
    end
  end

end

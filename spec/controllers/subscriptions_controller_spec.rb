require 'rails_helper'

describe SubscriptionsController do

    describe '.entrance' do

        let!(:user) { log_in(:bob) }

        context 'when biller is enabled' do

            before do
                SiteSetting.stubs(:allow_billings).returns(true)
                SiteSetting.stubs(:enabled_biller).returns('WHMCS')
            end

            describe 'user is not onboarded in biller' do
               it "should respond with onboarded_needed flag" do
                 xhr :get, :entrance
                   puts "------------ response"
                 expect(::JSON.parse(response.body)['error']).to be_present
               end
            end
=begin
            describe 'user activation is complete' do
               it "should redirect to root when activation is complete" do
                 xhr :get, :entrance
                 expect(response).to redirect_to('/')
               end
            end

            describe 'user is not approved then verify mobile' do

                it "should skip generating OTP with allow_phone_verification is false" do
                  xhr :get, :entrance
                  expect(::JSON.parse(response.body)['error']).to be_present
                end

                it 'should generate OTP with allow_phone_verification is true' do
                  xhr :get, :entrance
                  expect(::JSON.parse(response.body)['error']).to be_present
                end

                it 'should inform OTP failure with allow_phone_verification is true' do
                  xhr :get, :entrance
                  expect(::JSON.parse(response.body)['error']).to be_present
                end

            end

            describe 'user is not approved with external addon id' do
                it 'should have biller external id' do
                  xhr :get, :entrance
                  expect(::JSON.parse(response.body)['error']).to be_present
                end
            end

            describe 'user is not approved with biller subscription data' do
                it 'should return with details' do
                  xhr :get, :entrance
                  expect(::JSON.parse(response.body)['error']).to be_present
                end
            end

            describe 'deactivated user' do
                it 'should return an error' do
                     User.any_instance.stubs(:active).returns(false)
                     xhr :get, :entrance
                     expect(::JSON.parse(response.body)['error']).to be_present
                end
            end

        end

        context 'when billing is off' do

            before do
                SiteSetting.stubs(:allow_billings).returns(false)
            end

            it "shows the '/' page" do
                xhr :get, :entrance
                expect(response).to redirect_to('/')
            end
        end
=end
  end
    end
end

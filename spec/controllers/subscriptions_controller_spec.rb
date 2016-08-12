require 'rails_helper'

describe SubscriptionsController do


    describe '.entrance' do

        let!(:user) { log_in(:bob) }

        context 'when biller is enabled' do

            before do
                SiteSetting.stubs(:allow_billings).returns(true)
                SiteSetting.stubs(:enabled_biller).returns('WHMCS')
            end

            describe 'user signs up or login' do
                it "should respond with empty" do
                    xhr :get, :entrance
                    expect(response.body).not_to be_present
                end
            end
        end

        context 'when biller is not enabled' do

            before do
                SiteSetting.stubs(:allow_billings).returns(false)
                SiteSetting.stubs(:enabled_biller).returns('WHMCS')
            end

            describe 'user signs up or login' do
                it "should respond with empty" do
                    xhr :get, :entrance
                    expect(response.body).not_to be_present
                end
            end
        end
    end


    describe '.checker' do

        let!(:user) { log_in(:bob) }

        context 'when biller is enabled' do

            before do
                SiteSetting.stubs(:allow_billings).returns(true)
                SiteSetting.stubs(:enabled_biller).returns('WHMCS')
            end

            describe 'user is not onboarded in biller' do
                it "should respond with onboarded_needed flag" do
                    xhr :get, :checker
                    expect(::JSON.parse(response.body)['error']).to be_present
                end
            end

        end

        context 'when biller is enabled with approved' do

            before do
                SiteSetting.stubs(:allow_billings).returns(true)
                SiteSetting.stubs(:enabled_biller).returns('WHMCS')
                user.approved = true
            end

            it "should redirect to root when activation is complete" do
                puts "+++++++++ USER0"
                puts user.inspect
                puts "++++++++++++++"
                xhr :get, :checker
                expect(response).to redirect_to('/')
            end

        end

        context 'when biller is enabled with activated' do

            before do
                user.active = false
            end

            it "should redirect to root when activation is complete" do
                puts "+++++++++ USER1"
                puts user.inspect
                puts "++++++++++++++"
                xhr :get, :checker
                expect(response).to redirect_to('/')
            end

        end


        context 'when billing is off' do

            before do
                SiteSetting.stubs(:allow_billings).returns(false)
            end

            it "shows the '/' page" do
                xhr :get, :checker
                expect(response).to redirect_to('/')
            end
        end
    end
end

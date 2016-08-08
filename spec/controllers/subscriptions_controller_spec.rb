require 'rails_helper'

describe SessionsController do
=begin
    describe '.entrance' do

        let!(:user) { Fabricate(:bob) }

        context 'when billing is on' do
            before do
                user.find_by_email
            end

            #it "raises an error when the login isn't present" do
            #    expect { xhr :post, :create }.not_to raise_error
            #end

            describe 'not onboarded in biller' do
            #   it "should respond with onboarded_needed flag" do
            #   end
            end

            describe 'activation is complete' do
            #   it "should redirect to root when activation is complete" do
            #   end
            end

            describe 'unapproved user with mobile not verified' do

                it "should skip generating OTP with allow_phone_verification is false" do
                    User.any_instance.expects(:confirm_password?).never
                    xhr :post, :create, email: user.email, password: ('s' * (User.max_password_length + 1))
                    expect(::JSON.parse(response.body)['error']).to be_present
                end

                it 'should generate OTP with allow_phone_verification is true' do
                    User.any_instance.stubs(:suspended?).returns(true)
                    User.any_instance.stubs(:suspended_till).returns(2.days.from_now)
                    xhr :post, :create, email: user.email, password: 'myawesomepassword'
                    expect(::JSON.parse(response.body)['error']).to be_present
                end

                it 'should inform OTP failure with allow_phone_verification is true' do
                    User.any_instance.stubs(:suspended?).returns(true)
                    User.any_instance.stubs(:suspended_till).returns(2.days.from_now)
                    xhr :post, :create, email: user.email, password: 'myawesomepassword'
                    expect(::JSON.parse(response.body)['error']).to be_present
                end

            end

            describe 'unapproved user with external addon id' do
                it 'should biller external id' do
                    User.any_instance.stubs(:suspended?).returns(true)
                    User.any_instance.stubs(:suspended_till).returns(2.days.from_now)
                    xhr :post, :create, email: user.email, password: 'myawesomepassword'
                    expect(::JSON.parse(response.body)['error']).to be_present
                end
            end

            describe 'unapproved user with biller subscription' do
                it 'should return with details' do
                    User.any_instance.stubs(:suspended?).returns(true)
                    User.any_instance.stubs(:suspended_till).returns(2.days.from_now)
                    xhr :post, :create, email: user.email, password: 'myawesomepassword'
                    expect(::JSON.parse(response.body)['error']).to be_present
                end
            end

            describe 'deactivated user' do
                it 'should return an error' do
                    User.any_instance.stubs(:active).returns(false)
                    xhr :post, :create, email: user.email, password: 'mark4swagger'
                    expect(JSON.parse(response.body)['error']).not_to be_present
                end
            end


            describe 'also allow login by email' do
                before do
                    xhr :post, :create, email: user.email, password: 'mark4swagger'
                end

                it 'sets a session id' do
                    expect(session[:current_user_id]).to eq(user.email)
                end
            end
        end

        context 'when billing is off' do
            def post_login
                xhr :post, :create, email: user.email, password: 'strongpassword'
            end

            it "shows the '/' page" do
                post_login
                expect(JSON.parse(response.body)['error']).to be_present
            end
        end
    end
=end
end

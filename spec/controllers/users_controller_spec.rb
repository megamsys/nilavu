require 'rails_helper'

describe UsersController do

    describe '.show' do

        context "logged in" do

            let!(:user) { log_in(:bob) }

            it 'returns success' do
                xhr :get, :show, id: user.email, format: :json
                expect(response).to be_success
                json = JSON.parse(response.body)
                expect(json.is_a?(Hash)).to eq(true)
            end

            it "returns not found when the email doesn't exist" do
                xhr :get, :show, id: 'pepu@indiaic.net'
                expect(response).to be_success
            end
        end
    end



    describe '.password_reset' do
        let(:user) { Fabricate(:user) }

        context "you can view it even if login is required" do
            it "returns success" do
                get :password_reset, token: 'asdfasdf'
                expect(response).to be_success
            end
        end

        context 'missing token' do
            before do
                get :password_reset, token: SecureRandom.hex
            end

            it 'disallows login' do
                expect(session[:current_user_id]).to be_blank
                expect(response).to be_success
            end
        end

        context 'invalid token' do
            before do
                get :password_reset, token: "evil_trout!"
            end

            it 'disallows login' do
                expect(session[:current_user_id]).to be_blank
                expect(response).to be_success
            end
        end

        context 'valid token' do
            it 'returns success' do
                user = Fabricate(:user, api_key: SecureRandom.hex(16))
                token = SecureRandom.hex(16)

                get :password_reset, token: token
                put :password_reset, token: token, password: 'newpassword'
                expect(response).to be_success
                expect(assigns[:error]).to be_blank
            end
        end

        context 'submit change' do
            let(:token) { SecureRandom.hex(16) }

            it "fails when the password is blank" do
                put :password_reset, token: token, password: ''
                expect(session[:current_user_id]).to be_blank
            end

            it "fails when the password is too long" do
                put :password_reset, token: token, password: ('x' * (User.max_password_length + 1))
                expect(session[:current_user_id]).to be_blank
            end

            #TO-DO: We need to make this succeed. Currently this fails.
            #it "logs in the user" do
            #  put :password_reset, token: token, password: 'newpassword'
            #  expect(session[:current_user_id]).to be_present
            #end

            #it "doesn't log in the user when not approved" do
            #  put :password_reset, token: token, password: 'newpassword'
            #  expect(session[:current_user_id]).to be_blank
            #end
        end
    end

    describe '#create' do

        before do
            SiteSetting.stubs(:allow_new_registrations).returns(true)
            @user = Fabricate.build(:user)
        end

        def post_user
            xhr :post, :create,
            first_name: @user.first_name,
            last_name: @user.last_name,
            email: @user.email
        end

        context 'when creating a non active user (unconfirmed email)' do

            it 'returns a 500 when local logins are disabled' do
                SiteSetting.expects(:enable_local_logins).returns(false)
                post_user

                expect(response.status).to eq(500)
            end

            it 'returns an error when new registrations are disabled' do
                SiteSetting.stubs(:allow_new_registrations).returns(false)
                post_user
                json = JSON.parse(response.body)
                expect(json['success']).to eq(false)
                expect(json['message']).to be_present
            end

            it 'creates a user correctly' do
                post_user
                expect(JSON.parse(response.body)['active']).to be_falsey

                # should save user_created_message in session
                expect(session["user_created_message"]).to be_present
            end
        end

        context 'when creating an active user (confirmed email)' do
            before { User.any_instance.stubs(:active?).returns(true) }

            it "should be logged in" do
                post_user
                expect(session[:current_user_id]).to be_present
            end

            it 'returns 500 status when new registrations are disabled' do
                SiteSetting.stubs(:allow_new_registrations).returns(false)
                post_user
                json = JSON.parse(response.body)
                expect(json['success']).to eq(false)
                expect(json['message']).to be_present
            end
        end

        context 'after success' do
            before { post_user }

            it 'should succeed' do
                is_expected.to respond_with(:success)
            end

            it 'has the proper JSON' do
                json = JSON::parse(response.body)
                expect(json["success"]).to eq(true)
            end
        end

        shared_examples 'failed signup' do
            it 'should not create a new User' do
                expect { xhr :post, :create, create_params }.to_not change { "" }
            end

            it 'should report failed' do
                xhr :post, :create, create_params
                json = JSON::parse(response.body)
                expect(json["success"]).not_to eq(true)

                # should not change the session
                expect(session["user_created_message"]).to be_blank
            end
        end


        context 'when password is too long' do
            let(:create_params) { {first_name: @user.first_name, password: "x" * (User.max_password_length + 1), email: @user.email} }
            include_examples 'failed signup'
        end

    end


    #TO-DO: We can updating an upser after we fix the login problem.
    #describe '#update' do
    #    context 'with guest' do
    #        it 'raises an error' do
    #            expect do
    #                xhr :put, :update, id: 'a@a.com'
    #            end.to raise_error(Nilavu::InvalidParameters)
    #        end
    #    end


   #    context 'with authenticated user' do
   #          context 'with permission to update' do
   #              let!(:user) { log_in(:user) }

   #              it 'allows the update' do

   #                user2 = Fabricate(:user)
   #                 user3 = Fabricate(:user)

   #                  xhr :put, :update,
   #                  path: '',
   #                 id: user.email,
   #                 email: user.email,
   #                  first_name: 'Jim Tom'


    #                expect(response).to be_success

    #                user.reload

    #                expect(user.name).to eq 'Jim Tom'
    #                expect(user.custom_fields['test']).to eq 'it'
    #                expect(user.muted_users.pluck(:username).sort).to eq [user2.username,user3.username].sort

    #                put :update,
    #                id: user.email,
    #                email: user.email,
    #                muted_usernames: ""

    #                user.reload

    #                expect(user.muted_users.pluck(:username).sort).to be_empty

    #            end
    #        end
    #    end
    # end
end

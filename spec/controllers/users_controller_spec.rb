require 'rails_helper'

describe UsersController do
=begin
  describe '.show' do

      context "logged in" do

      let(:user) { log_in }

      it 'returns success' do
        xhr :get, :show, id: user.email, format: :json
        expect(response).to be_success
        json = JSON.parse(response.body)

        expect(json["user"]["has_title_badges"]).to eq(false)
      end

      it "returns not found when the email doesn't exist" do
        xhr :get, :show, id: 'pepu@indiaic.net'
        expect(response).not_to be_success
      end

      it 'returns not found when the user is inactive' do
        inactive = Fabricate(:user, active: 'false')
        xhr :get, :show, id: inactive.email
        expect(response).not_to be_success
      end



      describe "user profile views" do
        let(:other_user) { Fabricate(:user) }

        it "should track a user profile view for a signed in user" do
          UserProfileView.expects(:add).with(other_user.user_profile.id, request.remote_ip, user.id)
          xhr :get, :show, username: other_user.username
        end

        it "should not track a user profile view for a user viewing his own profile" do
          UserProfileView.expects(:add).never
          xhr :get, :show, email: user.email
        end

        it "should track a user profile view for an anon user" do
          UserProfileView.expects(:add).with(other_user.user_profile.id, request.remote_ip, nil)
          xhr :get, :show, username: other_user.username
        end

        it "skips tracking" do
          UserProfileView.expects(:add).never
          xhr :get, :show, { email: user.email, skip_track_visit: true }
        end
      end

      context "fetching a user by external_id" do
        before { user.create_single_sign_on_record(external_id: '997', last_payload: '') }

        it "returns fetch for a matching external_id" do
          xhr :get, :show, external_id: '997'
          expect(response).to be_success
        end

        it "returns not found when external_id doesn't match" do
          xhr :get, :show, external_id: '99'
          expect(response).not_to be_success
        end
      end

    end

  end

  describe '.user_preferences_redirect' do
    it 'requires the user to be logged in' do
      expect { get :user_preferences_redirect }.to raise_error(Nilavu::NotLoggedIn)
    end

    it "redirects to their profile when logged in" do
      user = log_in
      get :user_preferences_redirect
      expect(response).to redirect_to("/users/#{user.username_lower}/preferences")
    end
  end

  describe '.authorize_email' do
    it 'errors out for invalid tokens' do
      get :authorize_email, token: 'asdfasdf'
      expect(response).to be_success
      expect(flash[:error]).to be_present
    end

    context 'valid token' do
      it 'authorizes with a correct token' do
        user = Fabricate(:user)
        email_token = user.email_tokens.create(email: user.email)

        get :authorize_email, token: email_token.token
        expect(response).to be_success
        expect(flash[:error]).to be_blank
        expect(session[:current_user_id]).to be_present
      end
    end
  end

  describe '.activate_account' do
    before do
      UsersController.any_instance.stubs(:honeypot_or_challenge_fails?).returns(false)
    end

    context 'invalid token' do

      it 'return success' do
        EmailToken.expects(:confirm).with('asdfasdf').returns(nil)
        put :perform_account_activation, token: 'asdfasdf'
        expect(response).to be_success
        expect(flash[:error]).to be_present
      end
    end

    context 'valid token' do
      let(:user) { Fabricate(:user) }

      context 'welcome message' do
        before do
          EmailToken.expects(:confirm).with('asdfasdf').returns(user)
        end

        it 'enqueues a welcome message if the user object indicates so' do
          user.send_welcome_message = true
          user.expects(:enqueue_welcome_message).with('welcome_user')
          put :perform_account_activation, token: 'asdfasdf'
        end

        it "doesn't enqueue the welcome message if the object returns false" do
          user.send_welcome_message = false
          user.expects(:enqueue_welcome_message).with('welcome_user').never
          put :perform_account_activation, token: 'asdfasdf'
        end
      end


      context 'response' do
        before do
          Guardian.any_instance.expects(:can_access_forum?).returns(true)
          EmailToken.expects(:confirm).with('asdfasdf').returns(user)
          put :perform_account_activation, token: 'asdfasdf'
        end

        it 'returns success' do
          expect(response).to be_success
        end

        it "doesn't set an error" do
          expect(flash[:error]).to be_blank
        end

        it 'logs in as the user' do
          expect(session[:current_user_id]).to be_present
        end

        it "doesn't set @needs_approval" do
          expect(assigns[:needs_approval]).to be_blank
        end
      end

      context 'user is not approved' do
        before do
          Guardian.any_instance.expects(:can_access_forum?).returns(false)
          EmailToken.expects(:confirm).with('asdfasdf').returns(user)
          put :perform_account_activation, token: 'asdfasdf'
        end

        it 'returns success' do
          expect(response).to be_success
        end

        it 'sets @needs_approval' do
          expect(assigns[:needs_approval]).to be_present
        end

        it "doesn't set an error" do
          expect(flash[:error]).to be_blank
        end

        it "doesn't log the user in" do
          expect(session[:current_user_id]).to be_blank
        end
      end

    end
  end

  describe '.change_email' do
    let(:new_email) { 'bubblegum@adventuretime.ooo' }

    it "requires you to be logged in" do
      expect { xhr :put, :change_email, username: 'asdf', email: new_email }.to raise_error(Nilavu::NotLoggedIn)
    end

    context 'when logged in' do
      let!(:user) { log_in }

      it 'raises an error without an email parameter' do
        expect { xhr :put, :change_email, email: user.email }.to raise_error(ActionController::ParameterMissing)
      end

      it "raises an error if you can't edit the user's email" do
        Guardian.any_instance.expects(:can_edit_email?).with(user).returns(false)
        xhr :put, :change_email, email: new_email
        expect(response).to be_forbidden
      end

      context 'when the new email address is taken' do
        let!(:other_user) { Fabricate(:coding_horror) }
        it 'raises an error' do
          xhr :put, :change_email, email: other_user.email
          expect(response).to_not be_success
        end

        it 'raises an error if there is whitespace too' do
          xhr :put, :change_email, email: other_user.email + ' '
          expect(response).to_not be_success
        end
      end

      context 'when new email is different case of existing email' do
        let!(:other_user) { Fabricate(:user, email: 'case.insensitive@gmail.com')}

        it 'raises an error' do
          xhr :put, :change_email, email: other_user.email.upcase
          expect(response).to_not be_success
        end
      end

      it 'raises an error when new email domain is present in email_domains_blacklist site setting' do
        SiteSetting.email_domains_blacklist = "mailinator.com"
        xhr :put, :change_email, email: "not_good@mailinator.com"
        expect(response).to_not be_success
      end

      it 'raises an error when new email domain is not present in email_domains_whitelist site setting' do
        SiteSetting.email_domains_whitelist = "discourse.org"
        xhr :put, :change_email, email: new_email
        expect(response).to_not be_success
      end

      context 'success' do

        it 'has an email token' do
          expect { xhr :put, :change_email, email: new_email }.to change(EmailToken, :count)
        end

        it 'enqueues an email authorization' do
          Jobs.expects(:enqueue).with(:user_email, has_entries(type: :authorize_email, user_id: user.id, to_address: new_email))
          xhr :put, :change_email, email: new_email
        end
      end
    end

  end

  describe '.password_reset' do
    let(:user) { Fabricate(:user) }

    context "you can view it even if login is required" do
      it "returns success" do
        SiteSetting.login_required = true
        get :password_reset, token: 'asdfasdf'
        expect(response).to be_success
      end
    end

    context 'missing token' do
      before do
        get :password_reset, token: SecureRandom.hex
      end

      it 'disallows login' do
        expect(assigns[:error]).to be_present
        expect(session[:current_user_id]).to be_blank
        expect(assigns[:invalid_token]).to eq(nil)
        expect(response).to be_success
      end
    end

    context 'invalid token' do
      before do
        get :password_reset, token: "evil_trout!"
      end

      it 'disallows login' do
        expect(assigns[:error]).to be_present
        expect(session[:current_user_id]).to be_blank
        expect(assigns[:invalid_token]).to eq(true)
        expect(response).to be_success
      end
    end

    context 'valid token' do
      it 'returns success' do
        user = Fabricate(:user, auth_token: SecureRandom.hex(16))
        token = user.email_tokens.create(email: user.email).token

        old_token = user.auth_token

        get :password_reset, token: token
        put :password_reset, token: token, password: 'newpassword'
        expect(response).to be_success
        expect(assigns[:error]).to be_blank

        user.reload
        expect(user.auth_token).to_not eq old_token
        expect(user.auth_token.length).to eq 32
      end

      it "doesn't invalidate the token when loading the page" do
        user = Fabricate(:user, auth_token: SecureRandom.hex(16))
        email_token = user.email_tokens.create(email: user.email)

        get :password_reset, token: email_token.token

        email_token.reload
        expect(email_token.confirmed).to eq(false)
      end
    end

    context 'submit change' do
      let(:token) { EmailToken.generate_token }
      before do
        EmailToken.expects(:confirm).with(token).returns(user)
      end

      it "fails when the password is blank" do
        put :password_reset, token: token, password: ''
        expect(assigns(:user).errors).to be_present
        expect(session[:current_user_id]).to be_blank
      end

      it "fails when the password is too long" do
        put :password_reset, token: token, password: ('x' * (User.max_password_length + 1))
        expect(assigns(:user).errors).to be_present
        expect(session[:current_user_id]).to be_blank
      end

      it "logs in the user" do
        put :password_reset, token: token, password: 'newpassword'
        expect(assigns(:user).errors).to be_blank
        expect(session[:current_user_id]).to be_present
      end

      it "doesn't log in the user when not approved" do
        SiteSetting.expects(:must_approve_users?).returns(true)
        put :password_reset, token: token, password: 'newpassword'
        expect(assigns(:user).errors).to be_blank
        expect(session[:current_user_id]).to be_blank
      end
    end
  end

  describe '.confirm_email_token' do
    let(:user) { Fabricate(:user) }

    it "token doesn't match any records" do
      email_token = user.email_tokens.create(email: user.email)
      get :confirm_email_token, token: SecureRandom.hex, format: :json
      expect(response).to be_success
      expect(email_token.reload.confirmed).to eq(false)
    end

    it "token matches" do
      email_token = user.email_tokens.create(email: user.email)
      get :confirm_email_token, token: email_token.token, format: :json
      expect(response).to be_success
      expect(email_token.reload.confirmed).to eq(true)
    end
  end
=end
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
        puts response.body.inspect
        puts ":---- create :)"
        expect(JSON.parse(response.body)['active']).to be_falsey

        # should save user_created_message in session
        expect(session["user_created_message"]).to be_present
      end

      context "and 'must approve users' site setting is enabled" do
      #  before { SiteSetting.expects(:must_approve_users).returns(true) }

        it 'does not login the user' do
          post_user
          expect(session[:current_user_id]).to be_blank
        end

        it 'indicates the user is not active in the response' do
          post_user
          expect(JSON.parse(response.body)['active']).to be_falsey
        end

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

    #  it 'should not result in an active account' do
    #    expect(User.find_by_apikey({email: @user.email, api_key: @user.api_key}).active).to eq(false)
    #  end
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

    context 'when an Exception is raised' do
    #  [ ActiveRecord::StatementInvalid,
    #    RestClient::Forbidden ].each do |exception|
    #    before { User.any_instance.stubs(:save).raises(exception) }

    #    let(:create_params) {
    #      { name: @user.name, username: @user.username,
    #        password: "strongpassword", email: @user.email}
    #    }

    #    include_examples 'failed signup'
    #  end
    end

end

=begin
  describe '#update' do
    context 'with guest' do
      it 'raises an error' do
        expect do
          xhr :put, :update, username: 'guest'
        end.to raise_error(Nilavu::NotLoggedIn)
      end
    end

    context "as a staff user" do
      let!(:user) { log_in(:admin) }

      context "uneditable field" do
        let!(:user_field) { Fabricate(:user_field, editable: false) }

        it "allows staff to edit the field" do
          put :update, email: user.email, name: 'Jim Tom', user_fields: { user_field.id.to_s => 'happy' }
          expect(response).to be_success
          expect(user.user_fields[user_field.id.to_s]).to eq('happy')
        end
      end

    end

    context 'with authenticated user' do
      context 'with permission to update' do
        let!(:user) { log_in(:user) }

        it 'allows the update' do

          user2 = Fabricate(:user)
          user3 = Fabricate(:user)

          put :update,
                email: user.email,
                name: 'Jim Tom',
                custom_fields: {test: :it},
                muted_usernames: "#{user2.username},#{user3.username}"

          expect(response).to be_success

          user.reload

          expect(user.name).to eq 'Jim Tom'
          expect(user.custom_fields['test']).to eq 'it'
          expect(user.muted_users.pluck(:username).sort).to eq [user2.username,user3.username].sort

          put :update,
                email: user.email,
                muted_usernames: ""

          user.reload

          expect(user.muted_users.pluck(:username).sort).to be_empty

        end
      end

      context 'without permission to update' do
        it 'does not allow the update' do
          user = Fabricate(:user, name: 'Billy Bob')
          log_in_user(user)
          guardian = Guardian.new(user)
          guardian.stubs(:ensure_can_edit!).with(user).raises(Nilavu::InvalidAccess.new)
          Guardian.stubs(new: guardian).with(user)

          put :update, email: user.email, name: 'Jim Tom'

          expect(response).to be_forbidden
          expect(user.reload.name).not_to eq 'Jim Tom'
        end
      end
    end
  end

  describe '.destroy' do
    it 'raises an error when not logged in' do
      expect { xhr :delete, :destroy, username: 'nobody' }.to raise_error(Nilavu::NotLoggedIn)
    end

    context 'while logged in' do
      let!(:user) { log_in }

      it 'raises an error when you cannot delete your account' do
        Guardian.any_instance.stubs(:can_delete_user?).returns(false)
        UserDestroyer.any_instance.expects(:destroy).never
        xhr :delete, :destroy, email: user.email
        expect(response).to be_forbidden
      end

      it "raises an error when you try to delete someone else's account" do
        UserDestroyer.any_instance.expects(:destroy).never
        xhr :delete, :destroy, username: Fabricate(:user).username
        expect(response).to be_forbidden
      end

      it "deletes your account when you're allowed to" do
        Guardian.any_instance.stubs(:can_delete_user?).returns(true)
        UserDestroyer.any_instance.expects(:destroy).with(user, anything).returns(user)
        xhr :delete, :destroy, email: user.email
        expect(response).to be_success
      end
    end
  end

  describe '.my_redirect' do

    it "redirects if the user is not logged in" do
      get :my_redirect, path: "wat"
      expect(response).not_to be_success
      expect(response).to be_redirect
    end

    context "when the user is logged in" do
      let!(:user) { log_in }

      it "will not redirect to an invalid path" do
        get :my_redirect, path: "wat/..password.txt"
        expect(response).not_to be_redirect
      end

      it "will redirect to an valid path" do
        get :my_redirect, path: "preferences"
        expect(response).to be_redirect
      end

      it "permits forward slashes" do
        get :my_redirect, path: "activity/posts"
        expect(response).to be_redirect
      end
    end
  end

  describe '.check_emails' do

    it 'raises an error when not logged in' do
      expect { xhr :put, :check_emails, username: 'zogstrip' }.to raise_error(Nilavu::NotLoggedIn)
    end

    context 'while logged in' do
      let!(:user) { log_in }

      it "raises an error when you aren't allowed to check emails" do
        Guardian.any_instance.expects(:can_check_emails?).returns(false)
        xhr :put, :check_emails, username: Fabricate(:user).username
        expect(response).to be_forbidden
      end

      it "returns both email and associated_accounts when you're allowed to see them" do
        Guardian.any_instance.expects(:can_check_emails?).returns(true)
        xhr :put, :check_emails, username: Fabricate(:user).username
        expect(response).to be_success
        json = JSON.parse(response.body)
        expect(json["email"]).to be_present
        expect(json["associated_accounts"]).to be_present
      end

      it "works on inactive users" do
        inactive_user = Fabricate(:user, active: false)
        Guardian.any_instance.expects(:can_check_emails?).returns(true)
        xhr :put, :check_emails, username: inactive_user.username
        expect(response).to be_success
        json = JSON.parse(response.body)
        expect(json["email"]).to be_present
        expect(json["associated_accounts"]).to be_present
      end

    end

  end
=end
end

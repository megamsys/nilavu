require 'rails_helper'

describe SessionsController do

  describe '.create' do

    let!(:user) { Fabricate(:user) }

    context 'when email is confirmed' do
      before do
        user.find_by_email
      end

      it "raises an error when the login isn't present" do
        expect { xhr :post, :create }.to raise_error(ActionController::ParameterMissing)
      end

      describe 'invalid password' do
        it "should return an error with an invalid password" do
          xhr :post, :create, login: user.email, password: 'sssss'
          puts "---------------- invalidpw"
          puts response.body.inspect
          expect(::JSON.parse(response.body)['error']).to be_present
        end
      end

      describe 'invalid password' do
        it "should return an error with an invalid password if too long" do
          User.any_instance.expects(:confirm_password?).never
          xhr :post, :create, login: user.email, password: ('s' * (User.max_password_length + 1))
          expect(::JSON.parse(response.body)['error']).to be_present
        end
      end

      describe 'suspended user' do
        it 'should return an error' do
          User.any_instance.stubs(:suspended?).returns(true)
          User.any_instance.stubs(:suspended_till).returns(2.days.from_now)
          xhr :post, :create, login: user.email, password: 'myawesomepassword'
          expect(::JSON.parse(response.body)['error']).to be_present
        end
      end

      describe 'deactivated user' do
        it 'should return an error' do
          User.any_instance.stubs(:active).returns(false)
          xhr :post, :create, login: user.email, password: 'myawesomepassword'
          expect(JSON.parse(response.body)['error']).to eq(I18n.t('login.not_activated'))
        end
      end

      describe 'success by email' do
        it 'logs in correctly' do
          xhr :post, :create, login: user.email, password: 'myawesomepassword'

          user.reload

          expect(session[:current_user_id]).to eq(user.id)
          expect(user.auth_token).to be_present
          expect(cookies[:_t]).to eq(user.auth_token)
        end
      end

      describe 'local logins disabled' do
        it 'fails' do
          SiteSetting.stubs(:enable_local_logins).returns(false)
          xhr :post, :create, login: user.email, password: 'myawesomepassword'
          expect(response.status.to_i).to eq(500)
        end
      end

      describe 'strips leading @ symbol' do
        before do
          xhr :post, :create, login: "@" + user.email, password: 'myawesomepassword'
          user.reload
        end

        it 'sets a session id' do
          expect(session[:current_user_id]).to eq(user.id)
        end
      end

      describe 'also allow login by email' do
        before do
          xhr :post, :create, login: user.email, password: 'myawesomepassword'
        end

        it 'sets a session id' do
          expect(session[:current_user_id]).to eq(user.id)
        end
      end

      context 'login has leading and trailing space' do
        let(:email) { " #{user.email} " }

        it "strips spaces from the email" do
          xhr :post, :create, login: email, password: 'myawesomepassword'
          expect(::JSON.parse(response.body)['error']).not_to be_present
        end
      end

      describe "when the site requires approval of users" do
        before do
          SiteSetting.expects(:must_approve_users?).returns(true)
        end

        context 'with an unapproved user' do
          before do
            xhr :post, :create, login: user.email, password: 'myawesomepassword'
          end

          it "doesn't log in the user" do
            expect(session[:current_user_id]).to be_blank
          end

          it "shows the 'not approved' error message" do
            expect(JSON.parse(response.body)['error']).to eq(
              I18n.t('login.not_approved')
            )
          end
        end

        context "with an unapproved user who is an admin" do
          before do
            User.any_instance.stubs(:admin?).returns(true)
            xhr :post, :create, login: user.email, password: 'myawesomepassword'
          end

          it 'sets a session id' do
            expect(session[:current_user_id]).to eq(user.id)
          end
        end
      end
    end

    context 'when email has not been confirmed' do
      def post_login
        xhr :post, :create, login: user.email, password: 'myawesomepassword'
      end

      it "doesn't log in the user" do
        post_login
        expect(session[:current_user_id]).to be_blank
      end

      it "shows the 'not activated' error message" do
        post_login
        expect(JSON.parse(response.body)['error']).to eq(
          I18n.t 'login.not_activated'
        )
      end

      context "and the 'must approve users' site setting is enabled" do
        before { SiteSetting.expects(:must_approve_users?).returns(true) }

        it "shows the 'not approved' error message" do
          post_login
          expect(JSON.parse(response.body)['error']).to eq(
            I18n.t 'login.not_approved'
          )
        end
      end
    end
  end
=begin
  describe '.destroy' do
    before do
      @user = log_in
      xhr :delete, :destroy, id: @user.email
    end

    it 'removes the session variable' do
      expect(session[:current_user_id]).to be_blank
    end


    it 'removes the auth token cookie' do
      expect(cookies[:_t]).to be_blank
    end
  end

  describe '.forgot_password' do

    it 'raises an error without a email parameter' do
      expect { xhr :post, :forgot_password }.to raise_error(ActionController::ParameterMissing)
    end

    context 'for a non existant email' do
      it "doesn't generate a new token for a made up email" do
        expect { xhr :post, :forgot_password, login: 'made_up@go.com'}.not_to change(EmailToken, :count)
      end
    end

    context 'for an existing email' do
      let(:user) { Fabricate(:user) }

      it "returns a 500 if local logins are disabled" do
        SiteSetting.enable_local_logins = false
        xhr :post, :forgot_password, login: user.email
        expect(response.code.to_i).to eq(500)
      end

      it "generates a new token for a made up email" do
        expect { xhr :post, :forgot_password, login: user.email}.to change(EmailToken, :count)
      end
    end

    context 'do nothing to system email' do
      let(:system) { Nilavu.system_user }

      it 'generates no token for system username' do
        expect { xhr :post, :forgot_password, login: system.email}.not_to change(EmailToken, :count)
      end
    end

    context 'for a staged account' do
      let!(:staged) { Fabricate(:staged) }

      it 'generates no token for staged username' do
        expect { xhr :post, :forgot_password, login: staged.email}.not_to change(EmailToken, :count)
      end

      it 'enqueues no email' do
        Jobs.expects(:enqueue).never
        xhr :post, :forgot_password, login: staged.email
      end
    end
  end
=end
  describe '.current' do
    context "when not logged in" do
      it "retuns 404" do
        xhr :get, :current
        expect(response).not_to be_success
      end
    end

    #TO-DO: This will suceed with raj's patch
    # context "when logged in" do
    #   let!(:user) { log_in(:bob) }

    #  it "returns the JSON for the user" do
    #    xhr :get, :current
    #    expect(response).to be_success
    #    puts "----------------------"
    #    puts response.body.inspect
    #    puts "++++++++++++++++ when logged in"
    #    json = ::JSON.parse(response.body)
    #    expect(json['current_user']).to be_present
    #    expect(json['current_user']['id']).to eq(user.id)
    #  end
    #end
  end
end

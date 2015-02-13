class UsersController < ApplicationController
  respond_to :html, :js
  include UsersHelper
  include SessionsHelper
  before_filter :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_filter :correct_user, only: [:edit, :update]
  before_filter :admin_user, only: :destroy
  def index
    #Should list all the users of an organization.
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    current_user = @user
  end

  def new
    #  if params[:user_social_identity]
    if session[:auth]
      logger.debug "--> Users:new, creating new user with social identity."
      # @user = User.new(:email => params[:user_social_identity][:email], :first_name => params[:user_social_identity][:first_name], :last_name => params[:user_social_identity][:last_name], :phone => params[:user_social_identity][:phone])
      @user = User.new
      @social_uid = session[:auth][:uid]
      @email = session[:auth][:email]
      @firstname = session[:auth][:first_name]
      @lastname = session[:auth][:last_name]
      @phone = session[:auth][:phone]
    #   session.delete(:auth)
    end
  end

  def email_verify
    logger.debug "--> Users:email_verify, sending email verification."
    @user= User.find_by_verification_hash(params[:format])
    UserMailer.welcome_email(@user).deliver
    logger.debug "--> Users:email_verify, delivered verification email."
  end

  def verified_email
    @user= User.find_by_verification_hash(params[:format])
    if @user.verification_hash === params[:format]
      logger.debug "--> Users:verified_email, updating verified_email flag"
      @user.update_attribute(:verified_email, 'true')
      redirect_to signin_path(@user), :gflash => { :success => { :value => "Welcome back #{@user.first_name}. Your email #{@user.email} was verified. Thank you.", :sticky => false, :nodom_wrap => true } }
    else
      logger.debug "--> Users:verified_email, verification check failure."
      flash[:alert] = "Your verification failed. Resend the verification email again."
      redirect_to sign_up_path
    end
  end

  #This method is used to create a new user. The form parameters as entered during the
  #signup, is used to create a new user.
  #After a successful save : redirect to users dashboard.
  # failure with email already exists, then display a message with a link to forgot_password.
  # any other errors , display a general message, with an option to contact support.
  def create
    session.delete(:auth)
    logger.debug "--> Users:create, update social identity for new social identity user"
    @user = User.new
    @user_fields_form_type = params[:user_fields_form_type]
    params["remember_token"] = @user.generate_token
    if @user.save(params)
      sign_in params
      # fix for remember me: send the remember_me flag to sign_in method to decide if the user wishes to be remembered or not.
      logger.debug "==> Controller: users, Action: create, User signed in after creation"
      api_token = view_context.generate_api_token
      force_api(params["email"], api_token)
      options = { :id => "", :email => params["email"], :api_key => api_token, :authority => "admin" }
      res_body = CreateAccounts.perform(options)

      if !(res_body.class == Megam::Error)
        #update current user as onboard user(megam_api user)
        logger.debug "==> Controller: users, Action: create, User onboarded successfully"
        update_options = { "onboarded_api" => true, "api_token" => api_token }
        res_update = @user.update_columns(update_options, params["email"])
        if res_update
          if "#{Rails.configuration.support_email}".chop!
            begin
              
             @user.send_welcome_email(cookies)  #WELCOME EMAIL
              mail_res = "Email verification success"
            rescue Net::SMTPAuthenticationError, Net::SMTPServerBusy, Net::SMTPSyntaxError, Net::SMTPFatalError, Net::SMTPUnknownError => e
              mail_res = "Email verification Failed"
            end
          end
          #  redirect_to main_dashboards_path, :gflash => { :success => { :value => "Hi #{params["first_name"]}, #{res_body.some_msg[:msg]}", :sticky => false, :nodom_wrap => true } }
          redirect_to main_dashboards_path, :format => 'html', :notice => "Welcome #{params['first_name']}. Your #{mail_res}"
        else
          logger.debug "==> Controller: users, Action: create, User onboard was not successful"
          #redirect_to main_dashboards_path, :gflash => { :warning => { :value => "Sorry. We couldn't onboard #{@user.email} into our API server. Try again by updating the api key by clicking profile. If the error still persists, please contact #{ActionController::Base.helpers.link_to 'support !.', "http://support.megam.co/"}.", :sticky => false, :nodom_wrap => true } }
          redirect_to main_dashboards_path, :alert => " Gateway Failure.", :format => 'html'
        end
      else
        logger.debug "==> Controller: users, Action: create, User onboard was not successful"
        #redirect_to main_dashboards_path, :gflash => { :warning => { :value => "Sorry. We couldn't onboard #{@user.email} into our API server. Try again by updating the api key by clicking profile. If the error still persists, please contact #{ActionController::Base.helpers.link_to 'support !.', "http://support.megam.co/"}.", :sticky => false, :nodom_wrap => true } }
        redirect_to main_dashboards_path, :alert => "Gateway Failure.", :format => 'html'
      end

    else
      @user= User.find_by_email(params[:user][:email])
      if(@user)
        logger.debug "==> Controller: users, Action: create, User email duplicate"
        redirect_to signin_path, :gflash => { :warning => { :value => "Hey #{@user.first_name}, I know you already. Your email id is : #{@user.email}.", :sticky => false, :nodom_wrap => true } }
      else
        logger.debug "==> Controller: users, Action: create, Something went wrong! User not saved"
        redirect_to signup_path
      end

    end
  end

  def edituser
    if current_user_verify
      @user = User.new
      logger.debug "==> Controller: users, Action: edit, Start edit"
      @orgs = list_organizations
      @userdata= @user.find_by_email(current_user["email"])
      @accounts= list_accounts
    @userdata
    else
      redirect_to signin_path
    end
  end

  def upgrade
    logger.debug "==> Controller: users, Action: upgrade, Upgrade user from free to paid"
  end

  def userupdate
    if current_user_verify
      logger.debug "==> Controller: users, Action: update, Update user pw, api_key"
      @user = User.new
      @userdata = @user.find_by_email(current_user["email"])
      @user_fields_form_type = params[:user_fields_form_type]
      if @user_fields_form_type == 'api_key'
        logger.debug "User update For API key"
        api_token = generate_api_token
        options = { :id => "", :email => current_user["email"], :api_key => api_token, :authority => "admin" }
        @res_body = CreateAccounts.perform(options)
        if !(@res_body.class == Megam::Error)
          update_options = { "onboarded_api" => true, "api_token" => api_token, "updated_at" => Time.zone.now }
          res_update = @user.update_columns(update_options, current_user["email"])
          if res_update
            sign_in @userdata
            @res_msg = "API Key updated successfully"
            @err_msg = nil
          else
            @res_msg = nil
            @err_msg = "API Key update: Something went wrong! User not updated"
          end
        else
          @res_msg = nil
          @err_msg = "#{@res_body.some_msg[:msg]}"
        end
        respond_to do |format|
          format.js {
            respond_with(@res_msg, @err_msg, :user => current_user, :api_token => current_user["api_token"], :user_fields_form_type => params[:user_fields_form_type], :layout => !request.xhr? )
          }
        end
      elsif @user_fields_form_type == 'profile'
        update_options = { "first_name" => params[:first_name], "phone" => params[:phone] }
        res_update = @user.update_columns(update_options, current_user["email"])
        if res_update
          sign_in @userdata
          @res_msg = "Profile updated successfully"
          @err_msg = nil
        else
          @res_msg = nil
          @err_msg = "Profile update: Something went wrong! User not updated"
        end
        respond_to do |format|
          format.js {
            respond_with(@res_msg, @err_msg, :user => current_user, :api_token => current_user["api_token"], :user_fields_form_type => params[:user_fields_form_type], :layout => !request.xhr? )
          }
        end
      elsif @user_fields_form_type == 'password'
        if @user.password_decrypt(@userdata["password"]) == params[:current_password]
          if params[:password] == params[:password_confirmation]
            update_options = { "password" => @user.password_encrypt(params[:password]), "password_confirmation" => @user.password_encrypt(params[:password_confirmation]) }
            res_update = @user.update_columns(update_options, current_user["email"])
            if res_update
              sign_in @userdata
              @res_msg = "Password updated successfully"
              @err_msg = nil
            else
              @err_msg = "Password update: Something went wrong! User not updated"
              @res_msg = nil
            end
            respond_to do |format|
              format.js {
                respond_with(@res_msg, @err_msg, :user => current_user, :api_token => current_user["api_token"], :user_fields_form_type => params[:user_fields_form_type], :layout => !request.xhr? )
              }
            end
          else
            @res_msg = nil
            @err_msg = "Password update: The password's are doesn't match. Please re-enter the correct password."
            respond_to do |format|
              format.js {
                respond_with(@res_msg, @err_msg, :user => current_user, :api_token => current_user["api_token"], :user_fields_form_type => params[:user_fields_form_type], :layout => !request.xhr? )
              }
            end
          end
        else
          @res_msg = nil
          @err_msg = "Password update: The current password is wrong. Please re-enter the correct password."
          respond_to do |format|
            format.js {
              respond_with(@res_msg, @err_msg, :user => current_user, :api_token => current_user["api_token"], :user_fields_form_type => params[:user_fields_form_type], :layout => !request.xhr? )
            }
          end
        end
      end
    # render 'edit'
    else
      redirect_to signin_path
    end
  end

  def destroy
    User.find(params[:id]).destroy
    redirect_to users_path
  end

  def contact
    logger.debug "email address : #{params.inspect}"
    UserMailer.contact_email(params).deliver
  end

  private

  def correct_user
    if current_user_verify
      @user = User.find_by_email(current_user["email"])
      redirect_to(root_path) unless current_user?(@user)
    else
      redirect_to signin_path
    end
  end

  def admin_user
    if current_user_verify
      redirect_to(root_path) if current_user["admin"]
    else
      redirect_to signin_path
    end
  end

  def list_organizations
    if current_user_verify
      logger.debug "--> #{self.class} : list organizations entry"
      org_collection = ListOrganizations.perform(force_api[:email], force_api[:api_key])
      orgs = []

      if org_collection.class != Megam::Error
        org_collection.each do |one_org|
          orgs << {:name => one_org.name, :created_at => one_org.created_at.to_time.to_formatted_s(:rfc822)}
        end
        orgs = orgs.sort_by {|vn| vn[:created_at]}
      end
    orgs
    else
      redirect_to signin_path
    end
  end

  def list_accounts
    if current_user_verify
      logger.debug "--> #{self.class} : list accounts entry"
      acct_collection = ListAccounts.perform(force_api[:email], force_api[:api_key])
      accts = []

      if acct_collection.class != Megam::Error
        acct_collection.each do |one_acct|
          accts << {:name => one_acct.api_key, :created_at => one_acct.created_at.to_time.to_formatted_s(:rfc822)}
        end
        accts = accts.sort_by {|vn| vn[:created_at]}
      end
    accts
    else
      redirect_to signin_path
    end
  end
end

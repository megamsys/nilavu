class UsersController < ApplicationController
  respond_to :html, :js

  add_breadcrumb "Dashboard", :dashboards_path

  before_filter :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_filter :correct_user, only: [:edit, :update]
  before_filter :admin_user, only: :destroy
  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    if !@user.organization
      flash[:error] = "Hey ! Please update your profile to proceed further."
      redirect_to edit_user_path(current_user)
    end
    current_user = @user
  end

  def new
    if params[:user_social_identity]
      logger.debug "==> Controller: users, Action: new, New Social Identity User"
      @user = User.new(:email => params[:user_social_identity][:email], :first_name => params[:user_social_identity][:first_name], :last_name => params[:user_social_identity][:last_name], :phone => params[:user_social_identity][:phone])
      @social_uid = params[:user_social_identity][:uid]
    else
      @user = User.new
    end
    @user.build_organization
  end

  def email_verify
    logger.debug "==> Controller: users, Action: email_verify, Before Email verification"
    @user= User.find_by_verification_hash(params[:format])
    UserMailer.welcome_email(@user).deliver
    logger.debug "==> Controller: users, Action: email_verify, Email Verified"
  end

  def verified_email
    @user= User.find_by_verification_hash(params[:format])
    if @user.verification_hash === params[:format]
      logger.debug "==> Controller: users, Action: verified_email, Email Verified User comeback"
      @user.update_attribute(:verified_email, 'true')
      redirect_to signin_path(@user), :gflash => { :success => { :value => "Welcome back #{@user.first_name}. Your email #{@user.email} was verified. Thank you.", :sticky => false, :nodom_wrap => true } }
    else
      logger.debug "==> Controller: users, Action: verified_email, Wrong user attempt to comeback"
      flash[:alert] = "Ooops ! your verification failed. Sorry. resend the verification email again."
      redirect_to sign_up_path
    end
  end

  #This method is used to create a new user. The form parameters as entered during the
  #signup, is used to create a new user.
  #After a successful save : redirect to users dashboard.
  # failure with email already exists, then display a message with a link to forgot_password.
  # any other errors , display a general message, with an option to contact support.
  def create

    logger.debug "==> Controller: users, Action: create, Update socail identity for new social identity user"
    @user = User.new(params[:user])
    @user_fields_form_type = params[:user_fields_form_type]

    if @user.save
      if params[:social_uid]
        logger.debug "==> Controller: users, Action: create, Update socail identity for new social identity user"
        @identity = Identity.find_by_uid(params[:social_uid])
        @identity.update_attribute(:users_id, @user.id)
      end
      sign_in @user
      logger.debug "==> Controller: users, Action: create, User signed in after creation"
      options = { :id => current_user.id, :email => current_user.email, :api_key => current_user.api_token, :authority => "admin" }
      res_body = CreateAccounts.perform(options)
      flash[:success] = "Welcome #{current_user.first_name}"

      #Dashboard entry
      #puts("---------create---------->> entry")
      @dashboard=@user.dashboards.create(:name=> params[:user][:first_name])
      book_source = Rails.configuration.metric_source
      @widget=@dashboard.widgets.create(:name=>"graph", :kind=>"datapoints", :source=>book_source, :widget_type=>"pernode", :range=>"30-minutes")
      @widget=@dashboard.widgets.create(:name=>"totalbooks", :kind=>"totalbooks", :source=>book_source, :widget_type=>"summary", :range=>"30-minutes")
      @widget=@dashboard.widgets.create(:name=>"newbooks", :kind=>"newbooks", :source=>book_source, :widget_type=>"summary", :range=>"30-minutes")
      #@widget=@dashboard.widgets.create(:name=>"requests", :kind=>"requests", :source=>book_source, :widget_type=>"pernode")
      #@widget=@dashboard.widgets.create(:name=>"uptime", :kind=>"uptime", :source=>book_source, :widget_type=>"pernode")
      @widget=@dashboard.widgets.create(:name=>"queue", :kind=>"queue", :source=>book_source, :widget_type=>"summary", :range=>"30-minutes")
      @widget=@dashboard.widgets.create(:name=>"runningbooks", :kind=>"runningbooks", :source=>book_source, :widget_type=>"summary", :range=>"30-minutes")
      @widget=@dashboard.widgets.create(:name=>"cumulativeuptime", :kind=>"cumulativeuptime", :source=>book_source, :widget_type=>"summary", :range=>"30-minutes")
      #@widget=@dashboard.widgets.create(:name=>"requestserved", :kind=>"requestserved", :source=>book_source, :widget_type=>"pernode")
      @widget=@dashboard.widgets.create(:name=>"queuetraffic", :kind=>"queuetraffic", :source=>book_source, :widget_type=>"summary", :range=>"30-minutes")

      #@dashboard = Dashboard.new(:name=> params[:first_name], :user_id => current_user.id)

      if !(res_body.class == Megam::Error)
        #update current user as onboard user(megam_api user)
        logger.debug "==> Controller: users, Action: create, User onboarded successfully"
        logger.debug "==> Response : #{res_body.some_msg[:msg]}"
        @user.update_attribute(:onboarded_api, true)
        sign_in @user

        redirect_to dashboards_path, :gflash => { :success => { :value => "Hi #{current_user.first_name}, #{res_body.some_msg[:msg]}", :sticky => false, :nodom_wrap => true } }
      else
        logger.debug "==> Controller: users, Action: create, User onboard was not successfully"
        logger.debug "==> Response : #{res_body.some_msg[:msg]}"
        redirect_to dashboards_path, :gflash => { :warning => { :value => "Sorry. You are not yet onboard. Update profile.An error occurred while trying to register #{@user.email}. Try again. If it still persists, please contact #{ActionController::Base.helpers.link_to 'Our Support !.', "http://support.megam.co/"}. Error : #{res_body.some_msg[:msg]}", :sticky => false, :nodom_wrap => true } }
      end
    else
      @user= User.find_by_email(params[:user][:email])
      if(@user)
        logger.debug "==> Controller: users, Action: create, User email already existed"
        redirect_to signin_path, :gflash => { :warning => { :value => "Hey #{@user.first_name}, I know you already. Your email id is : #{@user.email}.", :sticky => false, :nodom_wrap => true } }
      else
      #flash[:alert] = "An error occurred while trying to register #{@user.email}. Try again. If it still persists, please contact #{ActionController::Base.helpers.link_to 'Our Support !.', new_password_reset_path}".html_safe
        logger.debug "==> Controller: users, Action: create, Something went wrong! User not saved"
        redirect_to signup_path
      end

    end
  end

  def edit
    logger.debug "==> Controller: users, Action: edit, Start edit"
    @user= User.find(params[:id])
    @user.organization
  end

  def upgrade
    logger.debug "==> Controller: users, Action: upgrade, Upgrade user from free to paid"
    add_breadcrumb "Dashboard", dashboards_path
    add_breadcrumb "Upgrade", upgrade_path
  end

  def update    
    logger.debug "User Update PARAMS===== ==> #{params}"
    @user=User.find(params[:id])
    logger.debug "@USER @ UPDATE ==> #{@user.inspect}"
    @organization=@user.organization || Organization.new
    @user_fields_form_type = params[:user_fields_form_type]
    if @user_fields_form_type == 'api_key'
      logger.debug "User update For API key"
      @api_token = SecureRandom.urlsafe_base64(nil, true)
      @user.update_attribute(:api_token, @api_token)
      sign_in @user

      options = { :id => current_user.id, :email => current_user.email, :api_key => current_user.api_token, :authority => "admin" }
      @res_body = CreateAccounts.perform(options)
      if !(@res_body.class == Megam::Error)
        #update current user as onboard user(megam_api user)
        @user.update_attribute(:onboarded_api, true)
        #@user.update_attributes(api_token: @api_token, onboarded_api: true)
        sign_in @user
        puts "TEST IF !ERROR"
        @res_msg = "successfully"
        puts "TEST IF !ERROR    -->  #{@res_body.some_msg[:msg]}"
      else
        puts "TEST else !ERROR"
        #@user.update_attribute(:api_token, @api_token)
        #sign_in @user
        @res_msg = "#{@res_body.some_msg[:msg]}"
        puts "ELSE @RES_MSG ====> "
        puts @res_msg
        puts @res_msg.class
      end
      respond_to do |format|
        format.js {
          respond_with(@res_msg, :user => current_user, :api_token => current_user.api_token, :user_fields_form_type => params[:user_fields_form_type], :layout => !request.xhr? )
        }
      end
    else
      logger.debug "User update !api_key"
      params[:user][:last_name] = @user.last_name if params[:user][:last_name].empty?
      params[:user][:phone] = @user.phone if params[:user][:phone].empty?
      if @user.update_attributes(params[:user])
        sign_in @user
        unless params[:user][:organization_attributes] && params[:user][:organization_attributes][:logo]
          respond_to do |format|
            format.js {
              respond_with(@user_fields_form_type, :user => current_user, :layout => !request.xhr? )
            }
          end
        else
          redirect_to dashboards_path
        end
      else
        render 'edit'
      end
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "Sorry to see you go. Removed successfully."
    redirect_to users_path
  end

  def contact
    logger.debug "email address : #{params.inspect}"
    UserMailer.contact_email(params).deliver
  end

  private

  def generate_api_token
    self.api_token = SecureRandom.urlsafe_base64(nil, true)
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless current_user?(@user)
  end

  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end

end

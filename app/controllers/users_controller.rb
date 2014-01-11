class UsersController < ApplicationController
  respond_to :html, :js
  include UsersHelper
  before_filter :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_filter :correct_user, only: [:edit, :update]
  before_filter :admin_user, only: :destroy
  def index
    #Should list all the users of an organization.
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    if !@user.organization
      redirect_to edit_user_path(current_user)
    end
    current_user = @user
  end

  def new
    if params[:user_social_identity]
      logger.debug "--> Users:new, creating new user with social identity."
      @user = User.new(:email => params[:user_social_identity][:email], :first_name => params[:user_social_identity][:first_name], :last_name => params[:user_social_identity][:last_name], :phone => params[:user_social_identity][:phone])
      @social_uid = params[:user_social_identity][:uid]
    else
      @user = User.new
    end
    @user.build_organization
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
    logger.debug "--> Users:create, update socail identity for new social identity user"
    @user = User.new(params[:user])
    @user_fields_form_type = params[:user_fields_form_type]

    if @user.save
      sign_in @user
      if params[:social_uid]
        logger.debug "--> Users:create, update socail identity for new social identity user"
        @identity = Identity.find_by_uid(params[:social_uid])
        @identity.update_column(:users_id, @user.id)
      end
      # fix for remember me: send the remember_me flag to sign_in method to decide if the user wishes to be remembered or not.
      logger.debug "==> Controller: users, Action: create, User signed in after creation"
      api_token = view_context.generate_api_token
      force_api(@user.email, api_token)
      options = { :id => @user.id, :email => @user.email, :api_key => api_token, :authority => "admin" }
      res_body = CreateAccounts.perform(options)
      dash(params[:user][:first_name])

      if !(res_body.class == Megam::Error)
        #update current user as onboard user(megam_api user)
        logger.debug "==> Controller: users, Action: create, User onboarded successfully"
        @user.update_columns(:onboarded_api => true, :api_token => api_token)
        redirect_to dashboards_path, :gflash => { :success => { :value => "Hi #{@user.first_name}, #{res_body.some_msg[:msg]}", :sticky => false, :nodom_wrap => true } }
      else
        logger.debug "==> Controller: users, Action: create, User onboard was not successful"
        redirect_to dashboards_path, :gflash => { :warning => { :value => "Sorry. We couldn't onbodard #{@user.email}. Try again by updating the api key by clicking profile. If the error still persists, please contact #{ActionController::Base.helpers.link_to 'Our Support !.', "http://support.megam.co/"}. Error : #{res_body.some_msg[:msg]}", :sticky => false, :nodom_wrap => true } }
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

  def edit
    add_breadcrumb "Profile", edit_user_path
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
    logger.debug "==> Controller: users, Action: update, Update user pw, org, api_key"    
    puts params[:user_fields_form_type]
    @user=User.find(params[:id])
    @organization=@user.organization || Organization.new
    @user_fields_form_type = params[:user_fields_form_type]
    if @user_fields_form_type == 'api_key'
      logger.debug "User update For API key"
      api_token = generate_api_token
      options = { :id => current_user.id, :email => current_user.email, :api_key => api_token,
        :authority => "admin" }
      @res_body = CreateAccounts.perform(options)
      if !(@res_body.class == Megam::Error)
        @user.update_columns(:onboarded_api => true, :api_token => api_token)
        sign_in @user
        @res_msg = "successfully"
      else
        @res_msg = "#{@res_body.some_msg[:msg]}"
      end
      respond_to do |format|
        format.js {
          respond_with(@res_msg, :user => current_user, :api_token => current_user.api_token, :user_fields_form_type => params[:user_fields_form_type], :layout => !request.xhr? )
        }
      end
    else
      logger.debug "User update !api_key"
      if @user.update_attributes(params[:user])
        sign_in @user        
        unless params[:user][:organzation_attributes] 
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
    redirect_to users_path
  end

  def contact
    logger.debug "email address : #{params.inspect}"
    UserMailer.contact_email(params).deliver
  end

  private

  def dash(first_name)
    @dashboard=@user.dashboards.create(:name=> first_name)
    # Move the widgets creation to widgets model and use mass insert
    #inserts = []
    # TIMES.times do
    #inserts.push "(3.0, '2009-01-23 20:21:13', 2, 1)"
    # end
    # sql = "INSERT INTO widgets (`name`, `datapoints`, 'source`, `widget_type`) VALUES #{inserts.join(", ")}"
    ##
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

  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless current_user?(@user)
  end

  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end

end

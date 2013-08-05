class UsersController < ApplicationController
  respond_to :html, :js

  add_breadcrumb "Home", :root_path
  #add_breadcrumb "Dashboard", :dashboard_path

  before_filter :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_filter :correct_user, only: [:edit, :update]
  before_filter :admin_user, only: :destroy
  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    add_breadcrumb "Dashboard", dashboard_path
    @user = User.find(params[:id])
    if !@user.organization
      flash[:error] = "Hey ! Please update your profile to proceed further."
      redirect_to edit_user_path(current_user)
    end
    current_user = @user
  end

  def new
    if params[:user_social_identity]
      @user = User.new(:email => params[:user_social_identity][:email], :first_name => params[:user_social_identity][:first_name], :last_name => params[:user_social_identity][:last_name], :phone => params[:user_social_identity][:phone])
      @social_uid = params[:user_social_identity][:uid]
    else
      @user = User.new
    end
    @user.build_organization
  end

  def forgot
  end

  def worker
    @user = current_user
    options = { :id => @user.id, :email => @user.email, :api_key => @user.api_token, :authority => "admin" }
    res_body = CreateAccounts.perform(options)
    puts "----------------------- SUCCESS--------------------------"
  #Resque.enqueue(WorkerClass, options)
  #success = Resque.enqueue(CreateAccounts, options)
  #HardWorker.perform_async('bob', 5)
  end

  def dashboard
    add_breadcrumb "dashboard", dashboard_path
=begin
@user = current_user
options = { :id => @user.id, :email => @user.email, :api_key => @user.api_token, :authority => "admin" }
puts "options====> #{options.inspect}"
#Resque.enqueue(WorkerClass, options)
success = Resque.enqueue(CreateAccounts, options)
=end
    add_breadcrumb "dashboard", dashboard_path
  end

  def email_verify
    logger.debug "users_controller:email_verify => entry"
    @user= User.find_by_verification_hash(params[:format])
    UserMailer.welcome_email(@user).deliver
    logger.debug "users_controller:email_verify => exit"
    redirect_to dashboard_path
  end

  def verified_email
    @user= User.find_by_verification_hash(params[:format])

    logger.debug "@user #{@user.to_yaml}"

    if @user.verification_hash === params[:format]
      @user.update_attribute(:verified_email, 'true')
      redirect_to signin_path(@user), :gflash => { :success => { :value => "Welcome back #{@user.first_name}. Your email #{@user.email} was verified. Thank you.", :sticky => false, :nodom_wrap => true } }
    else
      logger.debug "Wrong user"
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
    @user = User.new(params[:user])
    @user_fields_form_type = params[:user_fields_form_type]

    if @user.save
      if params[:social_uid]
        @identity = Identity.find_by_uid(params[:social_uid])
        @identity.update_attribute(:users_id, @user.id)
      end

      options = { :id => @user.id, :email => @user.email, :api_key => @user.api_token, :authority => "admin" }
      res_body = CreateAccounts.perform(options)
      puts "-----------------SUCCESS RES---------------"
      sign_in @user
      flash[:success] = "Welcome #{current_user.first_name}"
      if !(res_body.some_msg[:msg_type] == "error")
        #update current user as onboard user(megam_api user)
        @user.update_attribute(:onboarded_api, true)
        redirect_to dashboard_path, :gflash => { :success => { :value => "#{res_body.some_msg[:msg]}", :sticky => false, :nodom_wrap => true } }
      else
        redirect_to dashboard_path, :gflash => { :success => { :value => "Sorry. You are not yet onboard. Update profile. Error : #{res_body.some_msg[:msg]}", :sticky => false, :nodom_wrap => true } }
      end
    else
      @user= User.find_by_email(params[:user][:email])
      if(@user)
        flash[:error] = "Email #{@user.email} already exists.<div class='right'> #{ActionController::Base.helpers.link_to 'Forgot Password ?.', forgot_path}</div>".html_safe
      else
        flash[:alert] = "An error occurred while trying to register #{@user.email}. Try again. If it still persists, please contact #{ActionController::Base.helpers.link_to 'Our Support !.', forgot_path}".html_safe
      end
      render 'new'
    end
  end

  def edit
    @user= User.find(params[:id])
    @user.organization
  end

  def upgrade
    add_breadcrumb "Dashboard", dashboard_path
    add_breadcrumb "Upgrade", upgrade_path
  end

  def update
    sleep 2
    @user=User.find(params[:id])
    logger.debug "@USER @ UPDATE ==> #{@user.inspect}"
    @organization=@user.organization || Organization.new
    @user_fields_form_type = params[:user_fields_form_type]
    if @user_fields_form_type == 'api_key'
      @api_token = SecureRandom.urlsafe_base64(nil, true)
      if @user.update_attributes(api_token: @api_token)
        puts "TEST---------------> "
        sign_in @user
        respond_to do |format|

        #format.html { redirect_to dashboard_url, :gflash => { :success => { :value => "Welcome #{@user.first_name}. Your profile was updated successfully.", :sticky => false, :nodom_wrap => true } } }
          format.js {
            respond_with(:user => @user, :api_token => @api_token, :user_fields_form_type => params[:user_fields_form_type], :layout => !request.xhr? )
          }
        end
      else
        render 'edit'
      end
    else
      if @user.update_attributes(params[:user])
        sign_in @user
        respond_to do |format|
          format.html { redirect_to dashboard_path, :gflash => { :success => { :value => "Welcome #{@user.first_name}. Your profile was updated successfully.", :sticky => false, :nodom_wrap => true } } }
          format.js {
            respond_with(:user => @user, :user_fields_form_type => params[:user_fields_form_type], :layout => !request.xhr? )
          }
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

=begin
def following
@title = "Organization"
@user = User.find(params[:id])
@organization = @user.organizationfollowed_users.paginate(page: params[:page])
render 'show_org'
end

def apps
@title = "apps"
@user = User.find(params[:id])
@users = @user.apps.paginate(page: params[:page])
render 'show_apps'
end
=end

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

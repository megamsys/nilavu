class UsersController < ApplicationController
  respond_to :html, :js

  add_breadcrumb "Home", :root_path
  #add_breadcrumb "Dashboard", :dashboard_path

  before_filter :signed_in_user,
               only: [:index, :edit, :update, :destroy]
  before_filter :correct_user,   only: [:edit, :update]
  before_filter :admin_user,     only: :destroy
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
    @user = User.new
    @user.build_organization
  end

  def forgot

  end

  def dashboard
    add_breadcrumb "dashboard", dashboard_path
  end

  def email_verify
    logger.debug "users_controller:email_verify => entry"
    @user= User.find_by_verification_hash(params[:format])
    UserMailer.welcome_email(@user).deliver
    logger.debug "users_controller:email_verify => exit"
    redirect_to users_dashboard_url
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
  #        failure with email already exists, then display a message with a link to forgot_password.
  #        any other errors , display a general message, with an option to contact support.
  def create
    @user = User.new(params[:user])
    logger.debug "params-type----- #{params[:user]}"
    if @user.save
      sign_in @user
      redirect_to users_dashboard_url, :gflash => { :success => { :value => "Welcome  #{@user.first_name}. Created account #{@user.email} successfully.", :sticky => false, :nodom_wrap => true } }
    else
      @user= User.find_by_email(params[:user][:email])
      if(@user)
        flash[:error] = "Email #{@user.email} already exists.<div class='right'>  #{ActionController::Base.helpers.link_to 'Forgot Password ?.', forgot_path}</div>".html_safe
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
   sleep 5
    @user=User.find(params[:id])
    #temp_user=':id => params[:id], :first_name => params[:first_name], :last_name => params[:last_name], :email => params[:email], :phone => params[:phone]'
    logger.debug "params-type----- #{params[:id]}"
    logger.debug "params-type----- #{params[:first_name]}"
    @organization=@user.organization || Organization.new
    @user_fields_form_type = params[:user_fields_form_type]
    
    if @user.update_attributes(params[:user],first_name: params[:first_name], last_name: params[:last_name], email: params[:email], phone: params[:phone], password: params[:password], password_confirmation: params[:password_confirmation])
      
      sign_in @user

      respond_to do |format|
        flash_message = "Updated successfully"
        format.html { redirect_to users_dashboard_url, :gflash => { :success => { :value => "Welcome  #{@user.first_name}. Your profile was updated successfully.", :sticky => false, :nodom_wrap => true } } }
        format.js   {
          respond_with(:user => @user, :user_fields_form_type => params[:user_fields_form_type], :layout => !request.xhr? )
        }
      end
    #respond_with(@user, :layout => !request.xhr? )
    #redirect_to users_dashboard_url, :gflash => { :success => { :value => "Welcome  #{@user.first_name}. Your profile was updated successfully.", :sticky => false, :nodom_wrap => true } }
    else
      logger.debug "params---edit--- #{params[:user]}"
      render 'edit'
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

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless current_user?(@user)
  end

  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end
end

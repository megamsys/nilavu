class UsersController < ApplicationController

	add_breadcrumb "Home", :root_path
	#add_breadcrumb "Dashboard", :dashboard_path


  before_filter :signed_in_user,
    #            only: [:index, :edit, :update, :destroy, :following, :followers]
               only: [:index, :edit, :update, :destroy]
  before_filter :correct_user,   only: [:edit, :update]
  before_filter :admin_user,     only: :destroy
  def index
    @users = User.paginate(page: params[:page])

  end

  def show
	    add_breadcrumb "Dashboard", dashboard_path
   @user = User.find(params[:id])
    #@connector_project = ConnectorProject.all
    if !@user.organization
      flash[:error] = "Hey stranger. we need details about your work. Please update your work details to proceed further."
      redirect_to edit_user_path(current_user)
    end
current_user = @user
    logger.debug "show org #{@user.to_yaml}"
	logger.debug "CU #{current_user}"
	logger.debug "@CU #{@user}"

  end

  def new
    @user = User.new
    @user.build_organization

  end

 def forgot
	
 end

 def calendar
  end

 def dashboard
		    add_breadcrumb "dashboard", dashboard_path
 end

 def cloud_run
	    add_breadcrumb "Cloud Run", cloud_run_path
	    @cloud_runs = current_user.cloud_runs

 end


 def email_verify
	@user= User.find_by_verification_hash(params[:format])
	logger.debug "params befor mailer = #{params}"
	
	logger.debug "@user befor mailer = #{@user}"
	UserMailer.welcome_email(@user).deliver
	logger.debug "@user = #{@user}"
 end

  def verified_email
	@user= User.find_by_verification_hash(params[:format])
	logger.debug "@user #{@user.to_yaml}"
	if @user.verification_hash === params[:format]
	@user.update_attribute(:verified_email, 'true')
	#sign_in @user
	flash[:alert] = "Welcome back #{@user.first_name}. Your email #{@user.email} is verified. Thank you."
        redirect_to signin_path(@user)
	else
		logger.debug "Wrong user"
		flash[:alert] = "Sorry wrong verification"
		redirect_to sign_up_path
	end	
  end


  def create
    @user = User.new(params[:user])

    if @user.save
      sign_in @user
      flash[:alert] = "Welcome #{current_user.first_name}"
      redirect_to users_dashboard_url
    else
      render 'new'
    end
  end

  def edit

    @user= User.find(params[:id])

    @user.organization

  end

 

  def update

    @user=User.find(params[:id])
    @organization=@user.organization || Organization.new

    if @user.update_attributes(params[:user])
      logger.debug "user-update"

      sign_in @user
	
	logger.debug "update org #{@user.to_yaml}"
      redirect_to users_dashboard_url
	
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
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

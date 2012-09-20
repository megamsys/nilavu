class UsersController < ApplicationController
  before_filter :signed_in_user,
    #            only: [:index, :edit, :update, :destroy, :following, :followers]
               only: [:index, :edit, :update, :destroy]
  before_filter :correct_user,   only: [:edit, :update]
  before_filter :admin_user,     only: :destroy
  def index
    @users = User.paginate(page: params[:page])
    
  end

  def show
    
    @user = User.find(params[:id])
    if !@user.organization
          flash[:error] = "Please Create Organization Details first"
		redirect_to edit_user_path(current_user)
         end
    


  end

  def new
    @user = User.new
    @user.build_organization

  end

  def create
    @user = User.new(params[:user])

    if @user.save
      sign_in @user
      flash[:alert] = "Welcome #{current_user.first_name}"
      redirect_to customizations_show_url
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
	
	
      flash[:alert] = "Hi #{current_user.first_name},Your profile Updated Successfully"
      sign_in @user

      redirect_to @user
   
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

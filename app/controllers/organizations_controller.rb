class OrganizationsController < ApplicationController
  before_filter :signed_in_user
  def index

  end

  def new
    current_user.build_organization
  end

  def create

    #   @user = current_organization.users.build(params[:user])
    #   if @user.save
    #     flash[:success] = "User created!"
    #     redirect_to root_path
    #   else
    #     render 'static_pages/home'
    #   end
    #if !params[:organization].to_s.empty?
    #        @organization = @user.organizations.first || Organization.new
    #else
    # @organization = @user.organizations.build(params[:organization].slice!(:id))
    # end

  end

  def show
    @organization = Organization.find(params[:id])
    @users = @organization.users.paginate(page: params[:page])

  end

  def show_api_token

    if !current_user.organization
      flash[:error] = "Please Create Organization Details first"
      redirect_to edit_user_path(current_user)
    end

  end

  def create_api_access_key
    random_token = p SecureRandom.urlsafe_base64(nil, true)
    current_user.organization.update_attribute(:api_token, random_token)
    redirect_to organizations_show_api_token_url
  end

  def edit
  end

  def update

  end

  def delete
  end
end

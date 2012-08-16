class OrganizationsController < ApplicationController
  before_filter :signed_in_user
  def new
  end

  def show
    @organization = Organization.find(params[:id])
    @users = @organization.users.paginate(page: params[:page])

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

  def edit
  end

  def update

  end

  def delete
  end
end

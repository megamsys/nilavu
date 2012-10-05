class ConnectorsController < ApplicationController

 def index
     @connectors = Connector.paginate(page: params[:page])
 end

 def new  

    if !current_user.organization
      flash[:error] = "Please Create Organization Details first"
      redirect_to edit_user_path(current_user)
    #elsif !current_user.organization.cloud_app
    #flash[:error] = "Please Add any cloud Applications"
    #redirect_to new_apps_item_path
    else
    #elsif !current_user.organization.cloud_app.connectors

	@connector = Connector.new
     	current_user.organization.cloud_app.connectors.build(params[:connector])
	@products = Product.all
	@apps_item = current_user.organization.cloud_app.apps_items

    end
  end

  def create
    @user = current_user
    @connector = @user.organization.cloud_app.connectors.build(params[:connector]) || Connector.new(params[:connector])
    #@connector = current_user.organization.cloud_app.connectors.build(params[:connectors]) || Connector.new(params[:connectors])

    if @connector.save
      flash[:success] = "Connector Created."
      #redirect_to customizations_show_url
      @products = Product.all
      @apps_item = current_user.organization.cloud_app.apps_items
      render 'new'
    end
  end

  def update
    @connector=Connector.find(params[:id])
    if @connector.update_attributes(params[:connector])
      flash[:success] = "Connector #{current_user.organization.account_name} updated"
      @products = Product.all
      @apps_item = current_user.organization.cloud_app.apps_items
      render 'new'
    end
  end

end

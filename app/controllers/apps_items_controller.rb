class AppsItemsController < ApplicationController
  respond_to :html, :js

  def index
    breadcrumbs.add " Dashboard", :cloud_dashboards_path, :class => "icon icon-dashboard"
  end

  def new
    breadcrumbs.add "Cloud Applications", new_apps_item_path
    current_user.apps_items.build(params[:apps_items])
    @products = Product.all
    @apps_item = current_user.apps_items
  end

  def create
    @user = current_user
    @product = Product.find(params[:product_id])
    logger.debug "creating an item for product -> #{@product.id}"
    @apps_item = @user.apps_items.build(:product => @product) || AppsItem.new(params[:apps_item])
    @apps_item.save
    respond_with( @apps_item,@product, :layout => !request.xhr? )
  end

  # The update method right now is called to remove an already federated application. Removal of an federated application
  # will just blank out the my_url field. The row that was there before will remain in app_items table.
  # So essentially this will call the irornfist client to perform the action.
  # At this point ironfist is  just a class, but we'll design a Nilam::API to access and process stuff.
  # TO-DO : I don't this the update work currently. Needs to be fixed.
  def update
    logger.debug "apps_item_controller -entry"

    @app_item=AppsItem.find(params[:id])
    if @app_item.update_attributes(:my_url => params[:my_url])
      respond_with(@app_item, :layout => !request.xhr? )
    end
    logger.debug "apps_item_controller -exit"
  end

  # The destroy method removes an app_item only. ie. id/federation_type. The row that was there will be removed app_items table.
  # If a federation existed before, then we need to call the irornfist client to perform a fed removal action.
  # At this point ironfist is  just a class, but we'll design a Nilam::API to access and process stuff.
  # TO-DO : I don't this the update work currently. This basically removes the row from app_item table.
  #         Needs to be fixed.
  def destroy
    logger.debug "destroying an item for apps item -> #{params}"
    current_user.apps_items.find(params[:id]).destroy
    respond_with(@curent_user.apps_items, :layout => !request.xhr? )
  end
end

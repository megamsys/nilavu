class AppsItemsController < ApplicationController
  respond_to :html, :js
 
  def new
    current_user.organization.cloud_app.apps_items.build(params[:apps_items])
    @products = Product.all
    @apps_item = current_user.organization.cloud_app.apps_items
  end

  def create
    @user = current_user	
    @product = Product.find(params[:product_id])
    logger.debug "creating an item for product -> #{@product.id}"
    sleep 1 
    @apps_item = @user.organization.cloud_app.apps_items.build(:product => @product) || AppsItem.new(params[:apps_item])
    @apps_item.save
    respond_with( @apps_item,@product, :layout => !request.xhr? )
  end

  def destroy
    logger.debug "destroying an item for apps item -> #{params}"
	  sleep 1
    current_user.organization.cloud_app.apps_items.find(params[:id]).destroy
     @product = Product.find(params[:product_id])
    respond_with(@product, :layout => !request.xhr? )
  end
end

class AppsItemsController < ApplicationController
 respond_to :html, :js
 def new
		
	current_user.organization.cloud_app.apps_items.build(params[:apps_items])
	@products = Product.all
	@apps_item = current_user.organization.cloud_app.apps_items
	#@apps_items = AppsItem.all
	
	
 end

 def create
	@user = current_user
	product = Product.find(params[:product_id])
	@apps_item = @user.organization.cloud_app.apps_items.build(:product => product) || AppsItem.new(params[:apps_item])
	 @apps_item.save
	respond_with( @apps_item, :layout => !request.xhr? )
 end

 def destroy
     current_user.organization.cloud_app.apps_items.find(params[:id]).destroy
        respond_with( @apps_item, :layout => !request.xhr? )	
   # redirect_to apps_item_path(current_user)
 end
end

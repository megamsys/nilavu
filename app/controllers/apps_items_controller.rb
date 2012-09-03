class AppsItemsController < ApplicationController
 

  

  def new
	logger.debug "apps_items New"	
	current_user.organization.cloud_app.apps_items.build(params[:apps_items])
	@products = Product.all
	#@apps_items = AppsItem.all
	
end
 def create
	@user = current_user
	product = Product.find(params[:product_id])
	@apps_item = @user.organization.cloud_app.apps_items.build(:product => product) || AppsItem.new(params[:apps_item])
		
	if @apps_item.save
		redirect_to apps_item_path(current_user)
		flash[:success] = "Apps Items Created"
	end
  end
def show
end

  def destroy
    logger.debug "apps_items Destroy"
    current_user.organization.cloud_app.apps_items.find(params[:id]).destroy
    flash[:success] = "App Removed"
    redirect_to apps_item_path(current_user)
  end
end

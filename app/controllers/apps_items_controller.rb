class AppsItemsController < ApplicationController
 
def new
		
	current_user.organization.cloud_app.apps_items.build(params[:apps_items])
	@products = Product.all
	#@apps_items = AppsItem.all
	
end
 def create
	@user = current_user
	product = Product.find(params[:product_id])
	@apps_item = @user.organization.cloud_app.apps_items.build(:product => product) || AppsItem.new(params[:apps_item])
	 @apps_item.save

    respond_to do |format|
      format.html { redirect_to new_apps_item_path }
      format.js
    end	
     
  
	
  end
def display
end

  def destroy
     current_user.organization.cloud_app.apps_items.find(params[:id]).destroy
    
   # redirect_to apps_item_path(current_user)
    respond_to do |format|
      format.html { redirect_to new_apps_item_path }
      format.js
    end
  end
end

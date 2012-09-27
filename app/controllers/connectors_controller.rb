class ConnectorsController < ApplicationController

 def new
	@products = Product.all
	@apps_item = current_user.organization.cloud_app.apps_items
	respond_to do |format|
      format.html 
      format.js 
    end	
	
 end

 def create
 end

end

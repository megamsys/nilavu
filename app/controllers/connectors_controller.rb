class ConnectorsController < ApplicationController

 def new
   
   current_user.organization.cloud_app.connectors.build(params[:connectors])
	@products = Product.all
	@apps_item = current_user.organization.cloud_app.apps_items
	@connector = current_user.organization.cloud_app.connectors
	
end

 def create
  
   @connector = current_user.organization.cloud_app.connectors.build(params[:connectors]) || Connector.new(params[:connector])
   @connector.save
 end

end

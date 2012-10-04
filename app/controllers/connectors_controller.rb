class ConnectorsController < ApplicationController

 def new
   
   #current_user.organization.cloud_app.connectors.build(params[:connectors])
	@products = Product.all
	@apps_item = current_user.organization.cloud_app.apps_items
	#current_user.organization.cloud_app.connectors.build
	
end

 def create
  
   @connector = current_user.organization.cloud_app.connectors.build(params[:connectors]) || Connector.new(params[:connector])
   if @connector.save
     flash[:error] = "CONNECTOR CREATED"
     redirect_to customizations_show_url
   end
 end
 def update
    @connector=Connector.find(params[:id])
    if @connector.update_attributes(params[:connector])
      flash[:success] = "Connector #{current_user.organization.account_name} updated"
      redirect_to customizations_show_url
    end
  end

end

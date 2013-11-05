class CloudStoresController < ApplicationController
  def index
if current_user.cloud_books && current_user.cloud_books.find_by_book_type("BOLT")
    add_breadcrumb "CLoud Stores", cloud_stores_path
    cross_cloud_options = { :email => current_user.email, :api_key => current_user.api_token }
    @cloud_stores = ListPredefClouds.perform(cross_cloud_options)
    if @cloud_stores.class == Megam::Error
      redirect_to dashboards_path, :gflash => { :warning => { :value => "Oops! sorry, #{@cross_clouds.some_msg[:msg]}", :sticky => false, :nodom_wrap => true } }
    end
else
     redirect_to new_cloud_store_path, :gflash => { :warning => { :value => "Oops! sorry, You don't have cloud_store, create new'", :sticky => false, :nodom_wrap => true } }
end
  end

  def new
    logger.debug "Cloud Store new  ==> "
    add_breadcrumb "CLoud store", cross_clouds_path
    add_breadcrumb "New Cloud store selection", new_cross_cloud_path
  end

  def new_store
    logger.debug "New Store init Params ==> "
    logger.debug "#{params}"
    add_breadcrumb "CLoud Sore", cloud_stores_path
    add_breadcrumb "New Cloud Store selection", new_cloud_store_path
    add_breadcrumb "New Cloud Store selection", new_store_path
    @db_model = params[:db_model]
    @dbms = params[:dbms]
	@domain_name=".megam.co"
	    @book =  current_user.cloud_books.build
    @predef_name = params[:dbms]
    predef_cloud_options = { :email => current_user.email, :api_key => current_user.api_token }
    @predef_cloud = ListPredefClouds.perform(predef_cloud_options)
    predef_options = { :email => current_user.email, :api_key => current_user.api_token, :predef_name => @predef_name}
      pred = FindPredefsByName.perform(predef_options)
        @predef = pred.lookup(@predef_name)
  end


  def create
    logger.debug "Create Cloud store Params ==> "
    logger.debug "#{params}"
  end

  def show
  end
end

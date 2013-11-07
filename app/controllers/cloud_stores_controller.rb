class CloudStoresController < ApplicationController
  def index
if current_user.cloud_books && current_user.cloud_books.find_by_book_type("BOLT")
    add_breadcrumb "CLoud Stores", cloud_stores_path
    @cloud_stores = current_user.cloud_books.where(:book_type => 'BOLT')
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
	    @book =  current_user.cloud_books.build
    @predef_name = params[:dbms]
    predef_cloud_options = { :email => current_user.email, :api_key => current_user.api_token }
    predef_options = { :email => current_user.email, :api_key => current_user.api_token, :predef_name => @predef_name}
    @predef_cloud = ListPredefClouds.perform(predef_cloud_options)
    if @predef_cloud.class == Megam::Error
      redirect_to new_cloud_book_path, :gflash => { :warning => { :value => "#{@predef_cloud.some_msg[:msg]}", :sticky => false, :nodom_wrap => true } }
    else
    #if @predef_cloud.some_msg[:msg_type] != "error"
      pred = FindPredefsByName.perform(predef_options)
      if pred.class == Megam::Error
        redirect_to new_cloud_book_path, :gflash => { :warning => { :value => "#{pred.some_msg[:msg]}", :sticky => false, :nodom_wrap => true } }
      else
        @predef = pred.lookup(@predef_name)
        @domain_name = ".megam.co"
	@no_of_instances=params[:no_of_instances]
      end
    end


  end


  def create
    logger.debug "Create Cloud store Params ==> "
    logger.debug "#{params}"
  end

  def show
  end
end

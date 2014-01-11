class CloudStoresController < ApplicationController
  def index
    if current_user.cloud_books && current_user.cloud_books.find_by_book_type("BOLT")
      add_breadcrumb "Home", "#"
      add_breadcrumb "Manage Services", cloud_stores_path
      @cloud_stores = current_user.cloud_books.where(:book_type => 'BOLT')
    else
      redirect_to new_cloud_store_path, :gflash => { :success => { :value => "Create Your First Store.", :sticky => false, :nodom_wrap => true } }
    end
    end
=begin    
  def index
    add_breadcrumb "Database", cloud_stores_path
    if current_user.cloud_books && current_user.cloud_books.find_by_book_type("BOLT")
      cloud_stores = current_user.cloud_books.where(:book_type => 'BOLT')
      @nodes = FindNodesByEmail.perform
      if @nodes.class == Megam::Error
        redirect_to cloud_stores_path, :gflash => { :warning => { :value => "#{@nodes.some_msg[:msg]}", :sticky => false, :nodom_wrap => true } }
      else
        book_names = cloud_stores.map {|c| c.name}
        grouped = book_names.inject({}) do |base, b| #the grouped has a short_name/Megam::Nodes collection
          group = @nodes.select{|n| n.node_name =~ /^#{b}/}
          base[b] ||= []
          base[b] << group
          base
        end
        @launched_books = Hash[grouped.map {|key, value| [key, value.flatten.map {|vn| vn.node_name}]}]
        @launched_books_quota = @nodes.all_nodes.length
      end
    else
      @launched_books = {}
      @launched_books_quota = 0
      redirect_to cloud_store_path, :gflash => { :success => { :value => "Create Your First Store.", :sticky => false, :nodom_wrap => true } }
    end
  end
=end
  def new
    logger.debug "Cloud Store new  ==> "
    add_breadcrumb "Home", "#"
    add_breadcrumb "Manage Services", cross_clouds_path
    add_breadcrumb "New", new_cross_cloud_path
  end

  def new_store
    logger.debug "New Store init Params ==> "
    logger.debug "#{params}"
    add_breadcrumb "Home", "#"
    add_breadcrumb "Manage Services", cloud_stores_path
    add_breadcrumb "New", new_cloud_store_path
    @db_model = params[:db_model]
    @dbms = params[:dbms]
    @book =  current_user.cloud_books.build
    @predef_name = params[:dbms]
    predef_options = { :predef_name => @predef_name}
    @predef_cloud = ListPredefClouds.perform(force_api[:email], force_api[:api_key])
    if @predef_cloud.class == Megam::Error
      redirect_to new_cloud_book_path, :gflash => { :warning => { :value => "#{@predef_cloud.some_msg[:msg]}", :sticky => false, :nodom_wrap => true } }
    else
    #if @predef_cloud.some_msg[:msg_type] != "error"
      pred = FindPredefsByName.perform(predef_options,force_api[:email],force_api[:api_key])
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

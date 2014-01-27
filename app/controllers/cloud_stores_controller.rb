class CloudStoresController < ApplicationController
  respond_to :html, :js
  def index
       cloud_books = current_user.cloud_books.where(:book_type => 'BOLT')
    if cloud_books.any?
      add_breadcrumb "Home", "#"
      add_breadcrumb "Manage Services", cloud_stores_path
      @nodes = FindNodesByEmail.perform({},current_user.email, current_user.api_token)
      if @nodes.class == Megam::Error
        redirect_to new_cloud_book_path, :gflash => { :warning => { :value => "#{@nodes.some_msg[:msg]}", :sticky => false, :nodom_wrap => true } }
      else             
        book_names = cloud_books.map {|c| c.group_name}
        book_names = book_names.uniq
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
      redirect_to new_cloud_book_path
    end
    end


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
    wparams = {:node => "#{params[:name]}" }
    #look at storing in a local session, as we are redoing it. 
    # The node json is getting heavy as well    
    @node = FindNodeByName.perform(wparams,force_api[:email],force_api[:api_key])
    logger.debug "--> CloudBooks:show, found node #{wparams[:node]}"
    if @node.class == Megam::Error
      @res_msg="We went into nirvana, finding node #{wparams[:node]}. Open up a support ticket. We'll investigate its disappearence #{ActionController::Base.helpers.link_to 'Our Support !.', "http://support.megam.co/"}."
      respond_to do |format|
        format.js {
          respond_with(@res_msg, :layout => !request.xhr? )
        }
      end
    else
      @requests = GetRequestsByNode.perform(wparams,force_api[:email], force_api[:api_key])  #no error checking for GetRequestsByNode ? 
      @book_requests =  GetDefnRequestsByNode.send(params[:book_type].downcase.to_sym, wparams,force_api[:email], force_api[:api_key])
      if @book_requests.class == Megam::Error
        @book_requests={"results" => {"req_type" => "", "create_at" => "", "lc_apply" => "", "lc_additional" => "", "lc_when" => ""}}
      end
      @cloud_book = @node.lookup("#{params[:name]}")
      respond_to do |format|
        format.js {
          respond_with(@cloud_book, @requests, @book_requests, :layout => !request.xhr? )
        }
      end
    end
  end
end

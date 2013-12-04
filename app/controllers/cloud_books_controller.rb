class CloudBooksController < ApplicationController

  respond_to :html, :js
  add_breadcrumb "Dashboard", :dashboards_path
  def index
    if current_user.cloud_books.any?
      add_breadcrumb "Cloud_books", cloud_books_path
      @cloud_books = current_user.cloud_books
      logger.debug "Cloud Book Index ==> "
      options = { :email => current_user.email, :api_key => current_user.api_token }
      #@predef_clouds = ListPredefClouds.perform(options)
      @nodes = FindNodesByEmail.perform(options)
      if @nodes.class == Megam::Error
        #@res_msg="Sorry Something Wrong. Please contact #{ActionController::Base.helpers.link_to 'Our Support !.', "http://support.megam.co/"}."
        redirect_to new_cloud_book_path, :gflash => { :warning => { :value => "#{@nodes.some_msg[:msg]}", :sticky => false, :nodom_wrap => true } }
      else
        @n_hash=Hash.new
        @cloud_books = current_user.cloud_books
        @cloud_books.each do |cb|
          i=0
          ar=Array.new
          @nodes.each do |n|
            if n.node_name.start_with?(cb.name)
            #ar.push n.node_name
            ar[i]=n.node_name
            i += 1
            end
          end
          @n_hash["#{cb.name}"] = ar
        end
        puts "========================> N_ HASH <=========================== "
        puts @n_hash.inspect
        @cb_count = 0
        @n_hash.each do |k, v|
          @cb_count = @cb_count+v.count
        end
        puts "===============> Cloud Book COUNT <==================="
        puts @cb_count
      end
    else
      redirect_to new_cloud_book_path
    end
  end

  def build_request
=begin
tmp_hash = {
"req_type" => "#{params[:req]}",
"node_name" => "#{params[:name]}",
"appdefns_id" => "#{params[:defnsid]}",
"lc_apply" => "APPly",
"lc_additional" => "ADDition",
"lc_when" => "When"
}
=end
    @req_type = params[:req]
    @node_name = params[:name]
    @defns_id = params[:defnsid]
    respond_to do |format|
      format.js {
        respond_with(@req_type, @node_name, @defns_id, :layout => !request.xhr? )
      }
    end
  end

  def send_request

    puts "SEND REQUEST PARAMS===========> "
    puts params
    tmp_hash = {
      "req_type" => "#{params[:req_type]}",
      "node_name" => "#{params[:node_name]}",
      "lc_apply" => "#{params[:lc_apply]}",
      "lc_additional" => "#{params[:lc_additional]}",
      "lc_when" => "#{params[:lc_when]}"
    }
    if params[:defns_id].start_with?('A')
      tmp_hash["appdefns_id"] = "#{params[:defns_id]}"
      options = { :email => current_user.email, :api_key => current_user.api_token, :req => tmp_hash}
      @req = CreateAppRequests.perform(options)
    elsif params[:defns_id].start_with?('B')
      tmp_hash["boltdefns_id"] = "#{params[:defns_id]}"
      options = { :email => current_user.email, :api_key => current_user.api_token, :req => tmp_hash}
      @req = CreateBoltRequests.perform(options)
    end
    puts @req
    if @req.class == Megam::Error
      redirect_to cloud_books_path, :gflash => { :warning => { :value => "#{@req.some_msg[:msg]}", :sticky => false, :nodom_wrap => true } }
    else
      redirect_to cloud_books_path, :gflash => { :success => { :value => "#{@req.some_msg[:msg]}", :sticky => false, :nodom_wrap => true } }
    end

  #When to apply something in an applications cloud life cycle
  #If apache is started apply lc_apply else lc_addition
  #add_breadcrumb "Cloud_books", cloud_books_path
  #@cloud_books = current_user.cloud_books
  #logger.debug "Cloud Book Request ==> "
  #@book = CloudBook.find(params['format'])
  end

  def clone_build
    @node_name = "#{params[:name]}"
  end

  def clone_start
    get_node = { :email => current_user.email, :api_key => current_user.api_token, :node => "#{params[:clone_name]}" }
    @clone_nodes = FindNodeByName.perform(get_node)
    logger.debug "Get Node By Name NODE ==> clone==> "
    if @clone_nodes.class == Megam::Error
      @res_msg="Sorry Something Wrong. Please contact #{ActionController::Base.helpers.link_to 'Our Support !.', "http://support.megam.co/"}."
      respond_to do |format|
        format.js {
          respond_with(@res_msg, :layout => !request.xhr? )
        }
      end
    else
      @clone_node = @clone_nodes.lookup("#{params[:clone_name]}")

      node_hash = {
        "node_name" => "#{params[:new_name]}",
        "node_type" => "#{@clone_node.node_type}",
        "req_type" => "#{@clone_node.request[:req_type]}",
        "noofinstances" => params[:noofinstances].to_i,
        "command" => @clone_node.request[:command],
        "predefs" => @clone_node.predefs,
        "appdefns" => {"timetokill" => "", "metered" => "", "logging" => "", "runtime_exec" => ""},
        "boltdefns" => {"username" => "", "apikey" => "", "store_name" => "", "url" => "", "prime" => "", "timetokill" => "", "metered" => "", "logging" => "", "runtime_exec" => ""},
        "appreq" => {},
        "boltreq" => {}
      }
=begin
if data[:cloud_book][:book_type] == "APP"
node_hash["appdefns"] = {"timetokill" => "0", "metered" => "megam", "logging" => "megam", "runtime_exec" => "#{data['runtime_exec']}"}
end
if data[:cloud_book][:book_type] == "BOLT"
node_hash["boltdefns"] = {"username" => "#{data['user_name']}", "apikey" => "#{data['password']}", "store_name" => "#{data['store_db_name']}", "url" => "#{data['url']}", "prime" => "#{data['prime']}", "timetokill" => "", "metered" => "", "logging" => "", "runtime_exec" => "#{data['runtime_exec']}" }
end
=end

      options = { :email => current_user.email, :api_key => current_user.api_token, :node => node_hash }
      @node = CreateNodes.perform(options)
      if @node.class == Megam::Error
        @res_msg="Sorry Something Wrong. Please contact #{ActionController::Base.helpers.link_to 'Our Support !.', "http://support.megam.co/"}."
        respond_to do |format|
          format.js {
            respond_with(@res_msg, :layout => !request.xhr? )
          }
        end
      #redirect_to new_cloud_book_path, :gflash => { :warning => { :value => "#{@node.some_msg[:msg]}", :sticky => false, :nodom_wrap => true } }
      else

        @book = current_user.cloud_books.create(:name => params[:new_name], :predef_name => @clone_node.predefs[:name], :book_type => @clone_node.node_type, :domain_name => params[:domain_name], :predef_cloud_name => "default" )
        @book.save
=begin
if @node.request["req_id"]
params = {:book_name => "#{@book.name}#{@book.domain_name}", :request_id => @node.request["req_id"], :status => @node.status}
else
=end
        params = {:book_name => "#{@book.name}#{@book.domain_name}", :request_id => "req_id", :status => "status"}
        #end

        @history = @book.cloud_books_histories.create(params)
        @history.save

        redirect_to cloud_books_path, :gflash => { :success => { :value => "Cloud book cloned successfully", :sticky => false, :nodom_wrap => true } }
      end
    end
  end

def git_call
     logger.debug "================================= > Git CALL <========================= "
        auth_token = request.env['omniauth.auth']['credentials']['token']
        github = Github.new oauth_token: auth_token
        git_array = Array.new
        github.repos.all.each do |repo|
        	#puts repo
        	#puts "===========================> URL <============================================"
        	#puts repo.clone_url
        	git_array.push repo.clone_url
        end
        @repos = git_array
        puts "=========================================> GIT ARRAY <==================================== "
        puts @repos
        #render 'new'
          render :template => "cloud_books/new", :locals => {:repos => @repos}
        
end
  def new
    logger.debug ("================================= > CB STEP1 <========================= ")
    if current_user.onboarded_api
      @book =  current_user.cloud_books.build
      add_breadcrumb "Cloud_Books", cloud_books_path
      add_breadcrumb "New Cloud Platform Selection", new_cloud_book_path
    else
    #redirect_to user_path(:id => current_user.id, :user_fields_form_type => "api_key")
      redirect_to dashboards_path, :gflash => { :warning => { :value => "Sorry. You are not yet onboarded. Please update your profile", :sticky => false, :nodom_wrap => true } }
    end
  end

  def new_book
    add_breadcrumb "Cloud_Books", cloud_books_path
    add_breadcrumb "New Cloud_Platform Selection", new_cloud_book_path
    add_breadcrumb "Create", new_book_path
    @predef_name = params[:predef_name]
    if"#{params[:deps_scm]}".strip.length != 0
    @deps_scm = "#{params[:deps_scm]}"
    elsif !"#{params[:scm]}".start_with?("select")
    @deps_scm = "#{params[:scm]}"
    end
    @deps_war = "#{params[:deps_war]}" if params[:deps_war]
    @book =  current_user.cloud_books.build
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
  #else
  #redirect_to user_path(:id => current_user.id, :user_fields_form_type => "api_key")
  #   redirect_to dashboard_path, :gflash => { :error => { :value => "Sorry. You are not yet onboarded. Please do update your profile to proceed", :sticky => false, :nodom_wrap => true } }
  #end
  end

  #Upon creation of an entry in cloud_book_history, a request is sent to megam_play using the
  #resque background worker.
  def create
  
  data={:book_name => params[:cloud_book][:name], :book_type => params[:cloud_book][:book_type] , :predef_cloud_name => params[:cloud_book][:predef_cloud_name], :provider => params[:predef][:provider], :provider_role => params[:predef][:provider_role], :domain_name => params[:cloud_book][:domain_name], :no_of_instances => params[:no_of_instances], :predef_name => params[:predef][:name], :deps_scm => params['deps_scm'], :deps_war => "#{params['deps_war']}", :timetokill => "#{params['timetokill']}", :metered => "#{params['monitoring']}", :logging => "#{params['logging']}", :runtime_exec => "#{params['runtime_exec']}"} 

      puts "=======================================================> NEW NODE TEST I <================================================"
      puts data.inspect
      
  options = { :email => current_user.email, :api_key => current_user.api_token, :data => data, :group => "server", :action => "create" }
   
    node_hash=MakeNode.perform(options)
    
      puts "=======================================================> NEW NODE TEST <================================================"
      puts node_hash.inspect
      if node_hash.class == Megam::Error
         puts "================================================> Node Create ERROR========================================> "
         puts node_hash.inspect
            @res_msg="Sorry Something Wrong. MSG : #{node_hash.some_msg[:msg]} Please contact #{ActionController::Base.helpers.link_to 'Our Support !.', "http://support.megam.co/"}."
      respond_to do |format|
        format.js {
          respond_with(@res_msg, :layout => !request.xhr? )
        }
      end
      else
   options = { :email => current_user.email, :api_key => current_user.api_token, :node => node_hash }
    @node = CreateNodes.perform(options)
    if @node.class == Megam::Error
      @res_msg="Sorry Something Wrong. Please contact #{ActionController::Base.helpers.link_to 'Our Support !.', "http://support.megam.co/"}."
      respond_to do |format|
        format.js {
          respond_with(@res_msg, :layout => !request.xhr? )
        }
      end
    #redirect_to new_cloud_book_path, :gflash => { :warning => { :value => "#{@node.some_msg[:msg]}", :sticky => false, :nodom_wrap => true } }
    else

      @book = current_user.cloud_books.create(params[:cloud_book])
      @book.save
=begin
if @node.request["req_id"]
params = {:book_name => "#{@book.name}#{@book.domain_name}", :request_id => @node.request["req_id"], :status => @node.status}
else
=end
      params = {:book_name => "#{@book.name}#{@book.domain_name}", :request_id => "req_id", :status => "status"}
      #end

      @history = @book.cloud_books_histories.create(params)
    @history.save
    end
  end
end
  def show
    #@book = CloudBook.find(params[:id])
    get_node = { :email => current_user.email, :api_key => current_user.api_token, :node => "#{params[:name]}" }
    @node = FindNodeByName.perform(get_node)
    logger.debug "Get Node By Name NODE ==> "
    if @node.class == Megam::Error
      @res_msg="Sorry Something Wrong. Please contact #{ActionController::Base.helpers.link_to 'Our Support !.', "http://support.megam.co/"}."
      respond_to do |format|
        format.js {
          respond_with(@res_msg, :layout => !request.xhr? )
        }
      end
    #redirect_to new_cloud_book_path, :gflash => { :warning => { :value => "#{@node.some_msg[:msg]}", :sticky => false, :nodom_wrap => true } }
    else
      @requests = GetRequestsByNode.perform(get_node)
=begin
      if @requests.class == Megam::Error
      	@requests={"results" => [{"req_type" => "", "create_at" => "", "command" => "{}"}]}
      end
=end
      if params[:book_type] == "APP"
        @book_requests = GetAppRequestsByNode.perform(get_node)
      elsif params[:book_type] == "BOLT"
        @book_requests = GetBoltRequestsByNode.perform(get_node)
      end
          if @book_requests.class == Megam::Error
      		@book_requests={"results" => {"req_type" => "", "create_at" => "", "lc_apply" => "", "lc_additional" => "", "lc_when" => ""}}
#@book_requests={"results" => [Megam::AppRequest]}
          end
         puts "Book REQUEST CLASS==========================?> #{@book_requests.class}"
      @cloud_book = @node.lookup("#{params[:name]}")
      puts "@book_requests===========================> "
      puts @book_requests
      respond_to do |format|
        format.js {
          respond_with(@cloud_book, @requests, @book_requests, :layout => !request.xhr? )
        }
      end
    end
  end
  
  def clone
    sleep(5)
  end

  def destroy
    @book = CloudBook.find(params[:id])
    #get_node = { :email => current_user.email, :api_key => current_user.api_token, :node => "#{params[:name]}" }
    #@node = FindNodeByName.perform(get_node)
    
      options = { :email => current_user.email, :api_key => current_user.api_token, :node_name => "#{params[:name]}", :group => "server", :action => "delete" }
   
    node_hash=DeleteNode.perform(options)
    
      puts "=======================================================> NEW NODE TEST <================================================"
      puts node_hash.inspect
      
    if node_hash.class == Megam::Error
      @res_msg="Sorry Something Wrong. Please contact #{ActionController::Base.helpers.link_to 'Our Support !.', "http://support.megam.co/"}."
    else
      options = { :email => current_user.email, :api_key => current_user.api_token, :req => node_hash }
      @node = CreateRequests.perform(options)
      if @node.class == Megam::Error
        @res_msg="Sorry Something Wrong. MSG : #{@node.some_msg[:msg]} Please contact #{ActionController::Base.helpers.link_to 'Our Support !.', "http://support.megam.co/"}."
      else
        a = params[:n_hash]
        count = a["#{@book.name}"].count
        puts "TEST DELETE COUNT ==> #{count}"
        if count<2
          @book.cloud_books_histories.each do |cbh|
            cbh.destroy
          end
        @book.destroy
        end
        @res_msg = "Cloud Book deleted Successfully"

      end
    end

    respond_to do |format|
      format.js {
        respond_with(@res_msg, :layout => !request.xhr? )
      }
    end
  end

end

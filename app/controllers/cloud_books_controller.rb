class CloudBooksController < ApplicationController

  respond_to :html, :js
  add_breadcrumb "Dashboard", :dashboards_path
  def index
    if current_user.cloud_books.any?
      add_breadcrumb "Cloud_books", cloud_books_path
      @cloud_books = current_user.cloud_books
      logger.debug "Cloud Book Index ==> "
      options = { :email => current_user.email, :api_key => current_user.api_token }

      @nodes = FindNodesByEmail.perform(options)
      if @nodes.class == Megam::Error
        #@res_msg="Sorry Something Wrong. Please contact #{ActionController::Base.helpers.link_to 'Our Support !.', "http://support.megam.co/"}."
        redirect_to new_cloud_book_path, :gflash => { :warning => { :value => "#{@cloud_books.some_msg[:msg]}", :sticky => false, :nodom_wrap => true } }
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

  def new
    logger.debug ("================================= > CB STEP1 <========================= ")
    if current_user.onboarded_api
      @book =  current_user.cloud_books.build
      add_breadcrumb "Cloud_books", cloud_books_path
      add_breadcrumb "Cloud_book_platform_selection", new_cloud_book_path
    else
    #redirect_to user_path(:id => current_user.id, :user_fields_form_type => "api_key")
      redirect_to dashboards_path, :gflash => { :warning => { :value => "Sorry. You are not yet onboarded. Please update your profile", :sticky => false, :nodom_wrap => true } }
    end
  end

  def new_book
    logger.debug "================================= > CB NEW STEP2 <========================= "
    add_breadcrumb "Cloud_books", cloud_books_path
    add_breadcrumb "Cloud_book_platform_selection", new_cloud_book_path
    add_breadcrumb "Cloud_book_creation", new_book_path
    @predef_name = params[:predef_name]

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
    options = { :email => current_user.email, :api_key => current_user.api_token, :node => mk_node(params, "server", "create") }
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
	if params[:book_type] == "APP"
	    @book_requests = GetAppRequestsByNode.perform(get_node)
	elsif params[:book_type] == "BOLT"
	    @book_requests = GetBoltRequestsByNode.perform(get_node)
	end
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

  def destroy
    @book = CloudBook.find(params[:id])
    get_node = { :email => current_user.email, :api_key => current_user.api_token, :node => "#{params[:name]}" }
    @node = FindNodeByName.perform(get_node)

    if @node.class == Megam::Error
      @res_msg="Sorry Something Wrong. Please contact #{ActionController::Base.helpers.link_to 'Our Support !.', "http://support.megam.co/"}."
      respond_to do |format|
        format.js {
          respond_with(@res_msg, :layout => !request.xhr? )
        }
      end
    else
      @cloud_book = @node.lookup("#{params[:name]}")
      options = { :email => current_user.email, :api_key => current_user.api_token }
      @cloud_tools = ListCloudTools.perform(options)
      @tool = @cloud_tools.lookup(@cloud_book.request[:command]['systemprovider']['provider']['prov'])
      @template = @tool.cloudtemplates.lookup(@cloud_book.request[:command]['compute']['cctype'])
      @cloud_instruction = @template.lookup_by_instruction("server", "delete")

      n_name = params[:name]
      n_name = n_name[/[^.]+/]
      comm = "#{@cloud_instruction.command}"
      comm["<node_name>"]="#{n_name}"

      @com = {
"systemprovider" => {
"provider" => {
"prov" => "chef"
}
},
"compute" => {
"cctype" => "#{@cloud_book.request[:command]['compute']['cctype']}",
"cc" => {
"groups" => "",
"image" => "",
"flavor" => ""
},
"access" => {
"ssh_key" => "#{@cloud_book.request[:command]['compute']['access']['ssh_key']}",
"identity_file" => "#{@cloud_book.request[:command]['compute']['access']['identity_file']}",
"ssh_user" => "",
"vault_location" => "#{@cloud_book.request[:command]['compute']['access']['vault_location']}"
}
},
"cloudtool" => {
"chef" => {
"command" => "#{@cloud_book.request[:command]['cloudtool']['chef']['prov']}",
"plugin" => "#{@cloud_book.request[:command]['compute']['cctype']} #{comm}", #ec2 server delete or create
"run_list" => "",
"name" => "-N #{n_name}"
}
}
}

      node_hash = {
        "node_name" => "#{params[:name]}",
        "req_type" => "delete",
        "command" => @com
      }

      options = { :email => current_user.email, :api_key => current_user.api_token, :req => node_hash }
      @node = CreateRequests.perform(options)
      if @node.class == Megam::Error
        @res_msg="Sorry Something Wrong. Please contact #{ActionController::Base.helpers.link_to 'Our Support !.', "http://support.megam.co/"}."
        respond_to do |format|
          format.js {
            respond_with(@res_msg, :layout => !request.xhr? )
          }
        end
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
        redirect_to cloud_books_path, :gflash => { :success => { :value => "Cloud book and its histories are deleted successfully", :sticky => false, :nodom_wrap => true } }

      end
    end
  end

  private

  #build the required hash for the node and send it.
  #you can use Megam::Node itself to pass stuff.
  def mk_node(data, group, action)
    command = CreateCommand.perform(data, group, action, current_user)

    if command.class == Megam::Error
      #redirect_to new_cloud_book_path, :gflash => { :warning => { :value => "#{command.some_msg[:msg]}", :sticky => false, :nodom_wrap => true } }
      else
      logger.debug "Make command for chef run"

      node_hash = {
        "node_name" => "#{data[:cloud_book][:name]}#{data[:cloud_book][:domain_name]}",
        "node_type" => "#{data[:cloud_book][:book_type]}",
        "req_type" => "#{action}",
        "noofinstances" => data[:no_of_instances],
        "command" => command,
        "predefs" => {"name" => data[:predef][:name], "scm" => "#{data[:deps_scm]}",
          "db" => "postgres@postgresql1.megam.com/morning.megam.co", "war" => "#{data[:deps_war]}", "queue" => "queue@queue1", "runtime_exec" => data[:predef][:runtime_exec]},
        "appdefns" => {"timetokill" => "", "metered" => "", "logging" => "", "runtime_exec" => ""},
        "boltdefns" => {"username" => "", "apikey" => "", "store_name" => "", "url" => "", "prime" => "", "timetokill" => "", "metered" => "", "logging" => "", "runtime_exec" => ""},
        "appreq" => {},
        "boltreq" => {}
      }

      if data[:cloud_book][:book_type] == "APP"
        node_hash["appdefns"] = {"timetokill" => "0", "metered" => "megam", "logging" => "megam", "runtime_exec" => "#{data['runtime_exec']}"}
      end
      if data[:cloud_book][:book_type] == "BOLT"
        node_hash["boltdefns"] = {"username" => "#{data['user_name']}", "apikey" => "#{data['password']}", "store_name" => "#{data['store_db_name']}", "url" => "#{data['url']}", "prime" => "#{data['prime']}", "timetokill" => "", "metered" => "", "logging" => "", "runtime_exec" => "#{data['runtime_exec']}" }
      end
    end
    logger.debug "COMMAND HASH ==> #{node_hash.inspect}"

    node_hash
  end

end

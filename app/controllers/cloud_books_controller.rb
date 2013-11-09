class CloudBooksController < ApplicationController

  respond_to :html, :js
  add_breadcrumb "Dashboard", :dashboards_path
  def index
    if current_user.cloud_books.any?
      add_breadcrumb "Cloud_books", cloud_books_path
      @cloud_books = current_user.cloud_books
	logger.debug "Cloud Book Index ==> "
    else
      redirect_to new_cloud_book_path
    end
  end

  def definition
      add_breadcrumb "Cloud_books", cloud_books_path
      add_breadcrumb "Cloud_book's Definition", definition_path(params['format'])
      @cloud_books = current_user.cloud_books
	logger.debug "Cloud Book Definition ==> "
	puts params['format']
    @book = CloudBook.find(params['format'])
	puts @book.inspect
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
	puts "=================================> Predef COLLECTION <=============================================="
	puts pred.inspect
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
	puts "==================> @NODE in CB CREATE == > #{@node.inspect}"
    if @node.class == Megam::Error
      @res_msg="Sorry Something Wrong. Please contact #{ActionController::Base.helpers.link_to 'Our Support !.', "http://support.megam.co/"}."
      respond_to do |format|
        format.js {
          respond_with(@res_msg, :layout => !request.xhr? )
        }
      end
    #redirect_to new_cloud_book_path, :gflash => { :warning => { :value => "#{@node.some_msg[:msg]}", :sticky => false, :nodom_wrap => true } }
    else
	#i = 0
	no_of_nodes = params[:no_of_instances].to_i
for i in 1..no_of_nodes
 if current_user.cloud_books.count < 2
	params[:cloud_book][:name]="#{params[:cloud_book][:name]}#{i}"
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
  end

  def show
puts params
    @book = CloudBook.find(params[:id])
	get_node = { :email => current_user.email, :api_key => current_user.api_token, :node => "#{@book.name}#{@book.domain_name}" }
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
	@cloud_book = @node.lookup("#{@book.name}#{@book.domain_name}")
	if params["action_name"]
		@full_detail = true 
		@requests = "TEST"
      respond_to do |format|
        format.js {
          respond_with(@full_detail, @cloud_book, @requests, :layout => !request.xhr? )
        }
      end
	else
      respond_to do |format|
        format.js {
          respond_with(@cloud_book, :layout => !request.xhr? )
        }
      end
	end
    end
  end

  def destroy
    @book = CloudBook.find(params[:id])


@com = {
"systemprovider" => {
"provider" => {
"prov" => "chef"
}
},
"compute" => {
"cctype" => "ec2",
"cc" => {
"groups" => "",
"image" => "",
"flavor" => ""
},
"access" => {
"ssh_key" => "megam_ec2",
"identity_file" => "~/.ssh/megam_ec2.pem",
"ssh_user" => ""
}
},
"cloudtool" => {
"chef" => {
"command" => "knife",
"plugin" => "ec2 server delete", #ec2 server delete or create
"run_list" => "",
"name" => ""
}
}
}

        node_hash = {
          "node_name" => "#{@book.name}#{@book.domain_name}",
	"req_type" => "delete",
          "command" => @com
        }


    options = { :email => current_user.email, :api_key => current_user.api_token, :req => node_hash }
    @node = CreateRequests.perform(options)
	puts "==================> @NODE in CB CREATE == > #{@node.inspect}"
    if @node.class == Megam::Error
      @res_msg="Sorry Something Wrong. Please contact #{ActionController::Base.helpers.link_to 'Our Support !.', "http://support.megam.co/"}."
      respond_to do |format|
        format.js {
          respond_with(@res_msg, :layout => !request.xhr? )
        }
      end
    else
	@book.cloud_books_histories.each do |cbh|
		cbh.destroy
	end
	@book.destroy
	redirect_to cloud_books_path, :gflash => { :success => { :value => "Cloud book and its histories are deleted successfully", :sticky => false, :nodom_wrap => true } }

    end
  end



  private

  #build the required hash for the node and send it.
  #you can use Megam::Node itself to pass stuff.
  def mk_node(data, group, action)
    command = ListCloudTools.make_command(data, group, action, current_user)

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
          "predefs" => {"name" => data[:predef][:name], "scm" => data[:deps_scm],
            "db" => "postgres@postgresql1.megam.com/morning.megam.co", "war" => data[:deps_war], "queue" => "queue@queue1", "runtime_exec" => data[:predef][:runtime_exec]},
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

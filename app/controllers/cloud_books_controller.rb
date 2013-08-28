class CloudBooksController < ApplicationController

  respond_to :html, :js
  add_breadcrumb "Dashboard", :dashboards_path
  def index
    if current_user.cloud_books.any?
      add_breadcrumb "Cloud_books", cloud_books_path
      @cloud_books = current_user.cloud_books
    else
      redirect_to new_cloud_book_path
    end
  end

  def new
    logger.debug "================================= > CB STEP1 <========================= "
    if current_user.onboarded_api
      @book =  current_user.cloud_books.build
      add_breadcrumb "Cloud_books", cloud_books_path
      add_breadcrumb "Cloud_book_platform_selection", new_cloud_book_path
    else
    #redirect_to user_path(:id => current_user.id, :user_fields_form_type => "api_key")
      redirect_to dashboard_path, :gflash => { :error => { :value => "Sorry. You are not yet onboarded. Please update your profile", :sticky => false, :nodom_wrap => true } }
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
    puts "============================> @PREDEF LCOUD <==================================="
    puts @predef_cloud.inspect
    #if @predef_cloud.some_msg[:msg_type] != "error"
    pred = FindPredefsByName.perform(predef_options)
    @predef = pred.lookup(@predef_name)
    @domain_name = ".megam.co"
  #else
  #redirect_to user_path(:id => current_user.id, :user_fields_form_type => "api_key")
  #   redirect_to dashboard_path, :gflash => { :error => { :value => "Sorry. You are not yet onboarded. Please do update your profile to proceed", :sticky => false, :nodom_wrap => true } }
  #end
  end

  #Upon creation of an entry in cloud_book_history, a request is sent to megam_play using the
  #resque background worker.
  def create
    @book = current_user.cloud_books.create(params[:cloud_book])
    @domainname = @book.domain_name
    @book_id = @book.id

    if @book.save
      options = { :email => current_user.email, :api_key => current_user.api_token, :node => mk_node(params, "server", "create") }
      @node = CreateNodes.perform(options)
      puts "@NODE =================================== >>>> "
      puts @node.inspect
      if @node.request["req_id"]
        param = {:book_name => @book.name, :request_id => @node.request["req_id"], :status => @node.request["status"]}
      else
        param = {:book_name => @book.name, :request_id => "req_id", :status => "status"}
      end

      @history = @book.cloud_books_histories.create(param)
    @history.save

    else
      render 'new'
    end
  end

  def show
    puts "PARAMS SHOW ===> #{params}"
    @cloud_book = CloudBook.find(params[:id])
  end

  private

  #build the required hash for the node and send it.
  #you can use Megam::Node itself to pass stuff.
  def mk_node(data, group, action)

    command = ListCloudTools.make_command(data, group, action, current_user)
    puts "===========================> COMMAND <====================================="
    puts command
    unless data[:predef][:name] == "java"
      node_hash = {
        "node_name" => "#{data[:cloud_book][:name]}#{data[:cloud_book][:domain_name]}",
        "command" => "#{command}",
        "predefs" => {"name" => data[:predef][:name], "scm" => data[:cloud_book][:deps_scm],
          "db" => "postgres@postgresql1.megam.com/morning.megam.co", "war" => "", "queue" => "queue@queue1"}
      }
    else
      node_hash = {
        "node_name" => "#{data[:cloud_book][:name]}#{data[:cloud_book][:domain_name]}",
        "command" => "#{command}",
        "predefs" => {"name" => data[:predef][:name], "scm" => data[:cloud_book][:deps_scm],
          "db" => "postgres@postgresql1.megam.com/morning.megam.co", "war" => data[:cloud_book][:deps_war], "queue" => "queue@queue1"}
      }
    end
    node_hash
  end

end

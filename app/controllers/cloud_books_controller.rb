class CloudBooksController < ApplicationController

  respond_to :html, :js
  add_breadcrumb "Dashboard", :dashboard_path
  
  def index
    @cloud_books = CloudBook.paginate(page: params[:page])
  end
  
  def new
    if current_user.onboarded_api
      @book =  current_user.cloud_books.build
      add_breadcrumb "Cloud_book_platform_selection", new_cloud_book_path
    else
    #redirect_to user_path(:id => current_user.id, :user_fields_form_type => "api_key")
      redirect_to dashboard_path, :gflash => { :error => { :value => "Sorry. You are not yet onboarded. Please update your profile", :sticky => false, :nodom_wrap => true } }
    end
  end

  def new_book
    add_breadcrumb "Cloud_book_platform_selection", new_cloud_book_path
    add_breadcrumb "Cloud_book_platform_selection", new_book_path
    @predef_name = params[:predef_name]
    @book =  current_user.cloud_books.build
    predef_cloud_options = { :email => current_user.email, :api_key => current_user.api_token }
    predef_options = { :email => current_user.email, :api_key => current_user.api_token, :predef_name => @predef_name}
    @predef_cloud = ListPredefClouds.perform(predef_cloud_options)
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
      options = { :email => current_user.email, :api_key => current_user.api_token, :node => mk_node(params) }
      @node = CreateNodes.perform(options)
      if @node.request["req_id"]
        par = {:book_name => @book.name, :request_id => @node.request["req_id"], :status => @node.request["status"]}
      else
        par = {:book_name => @book.name, :request_id => "req_id", :status => "status"}
      end

      @history = @book.cloud_books_histories.create(par)
    @history.save

    else
      render 'new'
    end
  end

  private

  def mk_command(data)
	options = { :email => current_user.email, :api_key => current_user.api_token }
    @cloud_tools = ListCloudTools.perform(options)
@tool = @cloud_tools.lookup(data[:predef][:provider])
@template = @tool.cloudtemplates.lookup(@predef_cloud.spec[:type_name])
puts "CLOUD TOOL TEMPLATE=========================>>  "
puts @template.inspect
@cig = @template.lookup_by_group_name("server")
puts "CLoud TOol cloud_instructions_array cloudinstructions=================== >>>>>>> "
puts @cig.class
puts @cig.inspect
@cig1 = @template.lookup_by_instruction("server", "create")
puts "CLoud TOol cloud_instructions_array cloudinstructions SECOND 2=================== >>>>>>> "
puts @cig1.class
puts @cig1.inspect
puts "CLOUD INS ACTION CREATE ============================> "
#@cia = @cig["server"].cloud_instructions_array
	#puts @cia.class#.lookup("create")
	#puts @cia.inspect
	#@action = @cia.lookup("create")

    hash = {
      "systemprovider" => {
        "provider" => {
          "prov" => data[:predef][:provider]
        }
      },
      "compute" => {
        @predef_cloud.spec[:type_name] => {
          "image" => @predef_cloud.spec[:image],
          "flavor" => @predef_cloud.spec[:flavor]
        },
        "access" => {
          "ssh-key" => @predef_cloud.access[:ssh_key],
          "identity-file" => @predef_cloud.access[:identity_file],
          "ssh-user" => @predef_cloud.access[:ssh_user]
        }
      },
      "chefservice" => {
        "chef" => {
          "command" => @tool.cli,
          "plugin" => "#{@template.cctype} server create",
          "run-list" => "role[#{data[:predef][:provider_role]}]",
          "name" => data[:cloud_book][:name]
        }
      }
    }

puts "=====================================> HASH <===================================================="
puts hash
	hash
  end

  #build the required hash for the node and send it.
  #you can use Megam::Node itself to pass stuff.
  def mk_node(data)
    predef_cloud_options = { :email => current_user.email, :api_key => current_user.api_token }
    @predef_cloud_collection = ListPredefClouds.perform(predef_cloud_options)
    @predef_cloud = @predef_cloud_collection.lookup("#{params[:cloud_book][:predef_cloud_name]}")

    command = mk_command(data)

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

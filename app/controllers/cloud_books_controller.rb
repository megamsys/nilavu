class CloudBooksController < ApplicationController

  respond_to :html, :js
  add_breadcrumb "Dashboard", :dashboard_path
  
  def new
   if current_user.onboarded_api
    @book =  current_user.cloud_books.build
    add_breadcrumb "Cloud_book_platform_selection", new_cloud_book_path
   else
            redirect_to dashboard_path, :gflash => { :error => { :value => "Sorry. You are not yet onboarded. Please update your profile", :sticky => false, :nodom_wrap => true } }
   end
  end

def new_book
    add_breadcrumb "Cloud_book_platform_selection", new_cloud_book_path
    add_breadcrumb "Cloud_book_platform_selection", new_book_path
puts "PARAMS===> #{params}"
	@predef_name = params[:predef_name]
    @book =  current_user.cloud_books.build
	predef_cloud_options = { :email => current_user.email, :api_key => current_user.api_token }
	predef_options = { :email => current_user.email, :api_key => current_user.api_token, :predef_name => @predef_name}
	@predef_cloud = ListPredefClouds.perform(predef_cloud_options)
puts "TEST RES BODY------------------------->>>>>>>>>"
	@predef = FindPredefsByName.perform(predef_options)
	puts "PREDEF============>    "
	puts @predef
  end

  #Upon creation of an entry in cloud_book_history, a request is sent to megam_play using the
  #resque background worker.
  def create
puts "TEST CLOUD BOOK CREATE IF=============>>>>>>>>>>>> "
    @book = current_user.cloud_books.create(params[:cloud_book])
    @domainname = @book.domain_name
    @book_id = @book.id

    if @book.save
puts "TEST CLOUD BOOK CREATE IF SAVE=============>>>>>>>>>>>> "
      node_job = mk_node
    #success = Resque.enqueue(APINodes, node_job)
    else
      render 'new'
    end

  end
 

  private

  #build the required hash for the node and send it.
  #you can use Megam::Node itself to pass stuff.
  def mk_node
    tmp = {}
    tmp[:node_name] =@book.domain_name
    tmp.merge(defaults_for_api)
  end

end

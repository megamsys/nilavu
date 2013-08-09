class CloudBooksController < ApplicationController

  respond_to :html, :js
  add_breadcrumb "Dashboard", :dashboard_path
  
  def new
   if current_user.onboarded_api
    @book =  current_user.cloud_books.build
    add_breadcrumb "Cloud_book_create", new_cloud_book_path
	options = { :email => current_user.email, :api_key => current_user.api_token }
	@res_body = ListPredefClouds.perform(options)
puts "TEST RES BODY------------------------->>>>>>>>>"
	puts @res_body.inspect
   else
            redirect_to dashboard_path, :gflash => { :error => { :value => "Sorry. You are not yet onboarded. Please update your profile", :sticky => false, :nodom_wrap => true } }
   end

  end

  #Upon creation of an entry in cloud_book_history, a request is sent to megam_play using the
  #resque background worker.
  def create
	if params[:cloud_book][:predef_cloud_name]
    @book = current_user.cloud_books.create(params[:cloud_book])
    @domainname = @book.domain_name
    @book_id = @book.id

    if @book.save
      node_job = mk_node
    #success = Resque.enqueue(APINodes, node_job)
    else
      render 'new'
    end
	else
		
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

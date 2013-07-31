class CloudBooksController < ApplicationController

  respond_to :html, :js
  add_breadcrumb "Home", :root_path
  
  def new
    @book =  current_user.cloud_books.build
    add_breadcrumb "cloud_book_create", new_cloud_book_path

  end

  #Upon creation of an entry in cloud_book_history, a request is sent to megam_play using the
  #resque background worker.
  def create
    @book = current_user.cloud_books.create(params[:cloud_book])
    @domainname = @book.domain_name
    @book_id = @book.id
    if @book.save
      node_job = mk_node
    #success = Resque.enqueue(APINodes, node_job)
    else
      render 'new'
    end

  end

  def success_form
    add_breadcrumb "cloud_book_success", success_form_path
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

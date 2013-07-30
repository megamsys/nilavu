class CloudBooksHistoriesController < ApplicationController

  add_breadcrumb "Home", :root_path
  def index
    @books = current_user.cloud_books
  #@books = @cloud_books.cloud_books_histories
  end

  #Updon creation of an entry in cloud_book_history, a request is sent to megam_play using the
  #resque background worker.
  def create
    @books = current_user.cloud_books.find(params[:book_id])
    logger.debug("-------------------->"+Megam::Config[:email] + ","+ Megam::Config[:api_key])
    @books.cloud_books_histories.create(:book_id => params[:book_id], :book_name => params[:book_name])
    #node = node_h
    #output = Resque.enqueue(APINodesCreate, node)
    # before_api_exec
    redirect_to cloud_books_histories_path
  end

  private

  #build the required hash for the node and send it.
  #you can use Megam::Node itself to pass stuff.
  def node_h
    tmp = {}
    tmp[:something] ="yes"
    tmp
  end

end

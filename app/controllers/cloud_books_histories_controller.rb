class CloudBooksHistoriesController < ApplicationController
  respond_to :js, :html
  add_breadcrumb "Dashboard", :dashboards_path
  
  def index
 
  if current_user.cloud_books.any?
       add_breadcrumb "Logs", :root_path
       cloud_books = current_user.cloud_books
       @nodes = FindNodesByEmail.perform({},current_user.email, current_user.api_token)
      if @nodes.class == Megam::Error
        redirect_to new_cloud_book_path, :gflash => { :warning => { :value => "#{@nodes.some_msg[:msg]}", :sticky => false, :nodom_wrap => true } }
      end

  else
      redirect_to cloud_books_path, :gflash => { :warning => { :value => "Sorry. No logs available. Please create apps to see them.", :sticky => false, :nodom_wrap => true } }
    end
    #@books = current_user.cloud_books.all
  #@books = @cloud_books.cloud_books_histories
  end
  
  def new
  end

  def create
    @books = current_user.cloud_books.find(params[:book_id])
    @books.cloud_books_histories.create(:book_id => params[:book_id], :book_name => params[:book_name])
    redirect_to cloud_books_histories_path
  end

  

  def logs
    @books = current_user.cloud_books.all
    logger.debug "node_name_log ==> #{params[:node_name]}"
    @node_name = params[:node_name]
    respond_to do |format|
      format.js {
        respond_with(@node_name, :layout => !request.xhr? )
      }
    end

  end

end

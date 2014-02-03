class CloudBooksHistoriesController < ApplicationController
  respond_to :js, :html

  def index
    breadcrumbs.add "Dashboard", :cloud_dashboards_path
    breadcrumbs.add "Logs", :root_path
    @nodes = current_user.cloud_books.order("id DESC").all
    count = @nodes.length
    if count.to_i <= 0   
      redirect_to cloud_books_path, :gflash => { :warning => { :value => "Sorry. No logs available. Please create apps to see them.", :sticky => false, :nodom_wrap => true } }
    end
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

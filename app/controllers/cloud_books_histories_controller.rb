class CloudBooksHistoriesController < ApplicationController
  respond_to :js, :html

  def index
    breadcrumbs.add " Dashboard", :cloud_dashboards_path,  :class => "icon icon-dashboard"
    breadcrumbs.add "Logs", :root_path
    @nodes = current_user.cloud_books.order("id DESC").all
    count = @nodes.length
    if count.to_i <= 0   
      gflash :success => { :value => "You need apps to see logs. Go ahead, and launch it.. ", :sticky => false, :nodom_wrap => true } 
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
    @node_name = params[:node_name]
    respond_to do |format|
      format.js {
        respond_with(@node_name, :layout => !request.xhr? )
      }
    end

  end

end

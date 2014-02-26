class AppsHistoriesController < ApplicationController
  respond_to :js, :html

  def index
    breadcrumbs.add " Dashboard", :cloud_dashboards_path,  :class => "icon icon-dashboard"
    breadcrumbs.add "Logs", :root_path
    @nodes = current_user.apps.order("id DESC").all
    count = @nodes.length
    if count.to_i <= 0   
      gflash :success => { :value => "You need apps to see logs. Go ahead, and launch it.. ", :sticky => false, :nodom_wrap => true } 
    end
  end


  def new
  end

  def create
    @books = current_user.apps.find(params[:book_id])
    @books.apps_histories.create(:book_id => params[:book_id], :book_name => params[:book_name])
    redirect_to apps_histories_path
  end

  def logs
    @books = current_user.apps.all
    @node_name = params[:node_name]
    respond_to do |format|
      format.js {
        respond_with(@node_name, :layout => !request.xhr? )
      }
    end

  end

end

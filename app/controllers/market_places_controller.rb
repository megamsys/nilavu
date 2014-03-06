class MarketPlacesController < ApplicationController
  respond_to :html, :js
  def index
    breadcrumbs.add "Home", "#", :class => "fa fa-home", :target => "_self"
    breadcrumbs.add "MarketPlace", market_places_path, :target => "_self"
    mkp = get_marketplaces
    @mkp_collection = mkp[:mkp_collection]
    if @mkp_collection.class == Megam::Error
      redirect_to cloud_dashboards_path, :gflash => { :warning => { :value => "Oops! sorry, #{@mkp_collection.some_msg[:msg]}", :sticky => false, :nodom_wrap => true } }
    else
      @categories=[]
      @categories = @mkp_collection.map {|c| c.catagory}
      @categories = @categories.uniq
    end
  end  

  def market_place_app_show
    breadcrumbs.add "Home", "#", :class => "fa fa-home", :target => "_self"
    breadcrumbs.add "MarketPlace", market_places_path, :target => "_self"
    breadcrumbs.add "#{params[:name]}", market_places_path, :target => "_self"
    @mkp = params
    @catagory = params[:catagory]
    @logo = params[:logo]
    @my_apps = []
    cloud_books = current_user.apps.order("id DESC").all
    if cloud_books.any?
      @my_apps = cloud_books.map {|c| c.group_name}
      @my_apps = @my_apps.uniq
    else
      @my_apps << "No apps created."
    end
  end

  def category_view
    mkp = get_marketplaces
    @mkp_collection = mkp[:mkp_collection]
    if @mkp_collection.class == Megam::Error
      redirect_to cloud_dashboards_path, :gflash => { :warning => { :value => "Oops! sorry, #{@mkp_collection.some_msg[:msg]}", :sticky => false, :nodom_wrap => true } }
    else
      @categories=[]
      @categories = @mkp_collection.map {|c| c.catagory}
      @categories = @categories.uniq
      @category = params[:category]
      respond_to do |format|
        format.js {
          respond_with(@category, @mkp_collection, @categories, :layout => !request.xhr? )
        }
      end
    end
  end

  def get_marketplaces
    mkp_collection = ListMarketPlaceApps.perform(force_api[:email], force_api[:api_key])
    {:mkp_collection => mkp_collection}
  end

end

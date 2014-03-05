class MarketPlacesController < ApplicationController
  respond_to :html, :js
  def index
    breadcrumbs.add "Home", "#", :class => "icon icon-home", :target => "_self"
    breadcrumbs.add "MarketPlace", market_places_path, :target => "_self"
    mkp = get_marketplaces
    @mkp_collection = mkp[:mkp_collection]
    @categories = mkp[:categories] 
  end

  def new
    breadcrumbs.add "Home", "#", :class => "icon icon-home", :target => "_self"
    breadcrumbs.add "MarketPlace", market_place_path, :target => "_self"
    breadcrumbs.add "New", new_cloud_store_path, :target => "_self"
  end

  def market_place_app_show
    breadcrumbs.add "Home", "#", :class => "icon icon-home", :target => "_self"
    breadcrumbs.add "MarketPlace", market_places_path, :target => "_self"
    breadcrumbs.add "#{params[:name]}", market_places_path, :target => "_self"
    @mkp = params
    @catagory = params[:catagory]
    @logo = params[:logo]
  end

  def category_view    
    mkp = get_marketplaces
    @mkp_collection = mkp[:mkp_collection]
    @categories = mkp[:categories]   
    @category = params[:category]
    respond_to do |format|
      format.js {
        respond_with(@category, @mkp_collection, @categories, :layout => !request.xhr? )
      }
    end
  end
  
  def get_marketplaces
    mkp_collection = ListMarketPlaceApps.perform(force_api[:email], force_api[:api_key])
    if mkp_collection.class == Megam::Error
      redirect_to cloud_dashboards_path, :gflash => { :warning => { :value => "Oops! sorry, #{mkp_collection.some_msg[:msg]}", :sticky => false, :nodom_wrap => true } }
    end
    categories=[]
    categories = mkp_collection.map {|c| c.catagory}
    categories = categories.uniq
    {:mkp_collection => mkp_collection, :categories => categories}
  end

end

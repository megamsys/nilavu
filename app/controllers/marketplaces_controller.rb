class MarketplacesController < ApplicationController
  respond_to :html, :js
  include MarketplaceHelper
  def index
    breadcrumbs.add "Home", "#", :class => "fa fa-home", :target => "_self"
    breadcrumbs.add "MarketPlace", marketplaces_path, :target => "_self"
    mkp = get_marketplaces
    @mkp_collection = mkp[:mkp_collection]
    if @mkp_collection.class == Megam::Error
      redirect_to cloud_dashboards_path, :gflash => { :warning => { :value => "Oops! sorry, #{@mkp_collection.some_msg[:msg]}", :sticky => false, :nodom_wrap => true } }
    else
      @categories=[]
      @categories = @mkp_collection.map {|c| c.appdetails[:category]}
      @categories = @categories.uniq
    end
  end

  def show
    breadcrumbs.add "Home", "#", :class => "fa fa-home", :target => "_self"
    breadcrumbs.add "MarketPlace", marketplaces_path, :target => "_self"
    breadcrumbs.add "#{params[:id]}", marketplaces_path, :target => "_self"
    @mkp = GetMarketplaceApp.perform(force_api[:email], force_api[:api_key], params[:id])     
    if @mkp.class == Megam::Error
      redirect_to cloud_dashboards_path, :gflash => { :warning => { :value => "Oops! sorry, #{@mkp.some_msg[:msg]}", :sticky => false, :nodom_wrap => true } }
    else
      @mkp = @mkp.lookup(params[:id])    
      @predef_name = get_predef_name(params[:id])     
      @deps_scm = get_deps_scm(params[:id])
      @pricing = get_pricing
      @my_apps = []
      cloud_books = current_user.apps.order("id DESC").all
      if cloud_books.any?
        @my_apps = cloud_books.map {|c| c.name}
        @my_apps = @my_apps.uniq
      else
        @my_apps << "No apps created."
      end
    end
  end

  def category_view
    mkp = get_marketplaces
    @mkp_collection = mkp[:mkp_collection]
    if @mkp_collection.class == Megam::Error
      redirect_to cloud_dashboards_path, :gflash => { :warning => { :value => "Oops! sorry, #{@mkp_collection.some_msg[:msg]}", :sticky => false, :nodom_wrap => true } }
    else
      @categories=[]
      @categories = @mkp_collection.map {|c| c.appdetails[:category]}
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

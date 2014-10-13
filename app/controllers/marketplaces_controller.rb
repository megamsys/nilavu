class MarketplacesController < ApplicationController
  respond_to :html, :js
  include MarketplaceHelper
  def index

    mkp = get_marketplaces
    @mkp_collection = mkp[:mkp_collection]
    if @mkp_collection.class == Megam::Error
      redirect_to cloud_dashboards_path, :gflash => { :warning => { :value => "API server may be down. Please contact #{ActionController::Base.helpers.link_to 'support !.', "http://support.megam.co/", :target => "_blank"}.", :sticky => false, :nodom_wrap => true } }
    else
      @categories=[]
      @order=[]
      @order = @mkp_collection.map {|c| c.name}
      @order = @order.sort_by {|elt| ary = elt.split("-").map(&:to_i); ary[0] + ary[1]}
      @categories = @mkp_collection.map {|c| c.appdetails[:category]}
      @categories = @categories.uniq

    end
  end

  def show
    @pro_name = params[:id].split("-")

    @mkp = GetMarketplaceApp.perform(force_api[:email], force_api[:api_key], params[:id])
    if @mkp.class == Megam::Error
      redirect_to cloud_dashboards_path, :gflash => { :warning => { :value => "API server may be down. Please contact #{ActionController::Base.helpers.link_to 'support !.', "http://support.megam.co/", :target => "_blank"}.", :sticky => false, :nodom_wrap => true } }
    else
      @mkp = @mkp.lookup(params[:id])
      @predef_name = get_predef_name(@pro_name[1])
      @deps_scm = get_deps_scm(@pro_name[1])
      @my_apps = []
      cloud_books = current_user.apps.order("id DESC").all
      if cloud_books.any?
        @my_apps = cloud_books.map {|c| c.name}
        @my_apps = @my_apps.uniq
      else
        @my_apps << "No apps created."
      end
      @version_order=[]
      @version_order = @mkp.plans.map {|c| c["version"]}
      @version_order = @version_order.sort
    end
  end

  def category_view
    mkp = get_marketplaces
    @mkp_collection = mkp[:mkp_collection]
    if @mkp_collection.class == Megam::Error
       redirect_to cloud_dashboards_path, :gflash => { :warning => { :value => "API server may be down. Please contact #{ActionController::Base.helpers.link_to 'support !.', "http://support.megam.co/", :target => "_blank"}.", :sticky => false, :nodom_wrap => true } }
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

  def changeversion
    puts params[:version]
    @version = (params[:version].split(":"))[0]
    name = (params[:version].split(":"))[1]
    @mkp = GetMarketplaceApp.perform(force_api[:email], force_api[:api_key], name)
    if @mkp.class == Megam::Error
      redirect_to cloud_dashboards_path, :gflash => { :warning => { :value => "API server may be down. Please contact #{ActionController::Base.helpers.link_to 'support !.', "http://support.megam.co/", :target => "_blank"}.", :sticky => false, :nodom_wrap => true } }
    else
     @mkp = @mkp.lookup(name)
    respond_to do |format|
        format.js {
          respond_with(@version, @mkp, :layout => !request.xhr? )
        }
      end
    end
  end

end

require 'json'

class MarketplacesController < ApplicationController
  respond_to :js
  include MarketplaceHelper
  include AppsHelper
  
  def index  
    mkp = get_marketplaces
    @mkp_collection = mkp[:mkp_collection]
    if @mkp_collection.class == Megam::Error
      redirect_to main_dashboards_path, :gflash => { :warning => { :value => "API server may be down. Please contact #{ActionController::Base.helpers.link_to 'support !.', "http://support.megam.co/", :target => "_blank"}.", :sticky => false, :nodom_wrap => true } }
    else
      @categories=[]
      @order=[]
      @order = @mkp_collection.map {|c|
      puts c.name
      c.name
      }
      @order = @order.sort_by {|elt| ary = elt.split("-").map(&:to_i); ary[0] + ary[1]}
      @categories = @mkp_collection.map {|c| c.appdetails[:category]}
      @categories = @categories.uniq

    end
  end

  def show
    @pro_name = params[:id].split("-")

    @mkp = GetMarketplaceApp.perform(force_api[:email], force_api[:api_key], params[:id])
    if @mkp.class == Megam::Error
      redirect_to main_dashboards_path, :gflash => { :warning => { :value => "API server may be down. Please contact #{ActionController::Base.helpers.link_to 'support !.', "http://support.megam.co/", :target => "_blank"}.", :sticky => false, :nodom_wrap => true } }
    else
      @mkp = @mkp.lookup(params[:id])
      @predef_name = get_predef_name(@pro_name[3].downcase)
      @deps_scm = get_deps_scm(@pro_name[3].downcase)
      @my_apps = []

      @type = get_type(@pro_name[3].downcase)
      @version_order=[]
      @version_order = @mkp.plans.map {|c| c["version"]}
      @version_order = @version_order.sort

      puts @mkp.class
      respond_to do |format|
        format.js {
          respond_with(@mkp, @version_order, @type, :layout => !request.xhr? )
        }
      end
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
    @pro_name = params[:id].split("-")
    @version = params[:version]
    @mkp = GetMarketplaceApp.perform(force_api[:email], force_api[:api_key], params[:id])
    if @mkp.class == Megam::Error
      redirect_to main_dashboards_path, :gflash => { :warning => { :value => "API server may be down. Please contact #{ActionController::Base.helpers.link_to 'support !.', "http://support.megam.co/", :target => "_blank"}.", :sticky => false, :nodom_wrap => true } }
    else
      @mkp = @mkp.lookup(params[:id])
      @type = get_type(@pro_name[3].downcase)
      respond_to do |format|
        format.js {
          respond_with(@mkp, @version, @type, :layout => !request.xhr? )
        }
      end
    end

  end

  def create
    assembly_name = params[:name]
    version = params[:version]
    domain = params[:domain]
    cloud = params[:cloud]
    source = params[:source]
    type = params[:type].downcase
    dbname = nil
    dbpassword = nil

    combos = params[:combos]
    combo = combos.split("+")
    if combo.count > 1
      appname = params[:combo1]
      servicename = params[:combo2]
    else
      if params.has_key?("bindedAPP")
        servicename = params[:combo1]
        if params[:bindedAPP] != "" && params[:bindedAPP] != "select your APP"
          appname = params[:bindedAPP]
        else 
          appname = nil  
        end
      else
        appname = params[:combo1]
        servicename = nil
      end
    end
    
    if type == "postgresql"
      dbname = current_user.email
      dbpassword = ('0'..'z').to_a.shuffle.first(8).join
    end

    options = {:assembly_name => assembly_name, :appname => appname, :servicename => servicename, :component_version => version, :domain => domain, :cloud => cloud, :source => source, :type => type, :combo => combo, :dbname => dbname, :dbpassword => dbpassword  }
    app_hash=MakeAssemblies.perform(options, force_api[:email], force_api[:api_key])
    @res = CreateAssemblies.perform(app_hash,force_api[:email], force_api[:api_key])
    if @res.class == Megam::Error
      @err_msg="Please contact #{ActionController::Base.helpers.link_to 'support !.', "http://support.megam.co/"}."
      respond_to do |format|
        format.js {
          respond_with(@err_msg, :layout => !request.xhr? )
        }
      end
    end
  end

end
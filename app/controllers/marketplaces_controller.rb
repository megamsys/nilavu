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
    @apps = get_apps
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

  def get_apps
    apps = []
    if current_user
      @user_id = current_user.id

      @assemblies = ListAssemblies.perform(force_api[:email],force_api[:api_key])
      @service_counter = 0
      @app_counter = 0
      if @assemblies != nil
        @assemblies.each do |asm|
          if asm.class != Megam:: Error
            asm.assemblies.each do |assembly|
              if assembly != nil
                if assembly[0].class != Megam::Error

                  assembly[0].components.each do |com|
                    if com != nil
                      com.each do |c|
                        com_type = c.tosca_type.split(".")
                        ctype = get_type(com_type[2])
                        if ctype == "APP" && com[0].related_components == ""
                          apps << {"name" => assembly[0].name + "." + assembly[0].components[0][0].inputs[:domain] + "/" + com[0].name, "aid" => assembly[0].id, "cid" => assembly[0].components[0][0].id }
                        end
                      end
                    end
                  end

                  assembly[0].components.each do |com|
                    if com != nil
                      com.each do |c|
                        com_type = c.tosca_type.split(".")
                        ctype = get_type(com_type[2])
                        if ctype == "APP"
                          @app_counter = @app_counter + 1
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end

    else
      redirect_to signin_path
    end
    apps
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

  def starter_packs_create
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
    appname = params[:appname]
    servicename = params[:servicename]

    predef = GetPredefCloud.perform(params[:cloud], force_api[:email], force_api[:api_key])
    if predef.class == Megam::Error
      @err_msg="Please contact #{ActionController::Base.helpers.link_to 'support !.', "http://support.megam.co/"}."
      respond_to do |format|
        format.js {
          respond_with(@err_msg, :layout => !request.xhr? )
        }
      end
    else
     # if predef[0].spec[:type_name] == "docker"
       # ttype = "tosca.docker."
     # else
        ttype = "tosca.web."
      #end

      options = {:assembly_name => assembly_name, :appname => appname, :servicename => servicename, :component_version => version, :domain => domain, :cloud => cloud, :source => source, :ttype => ttype, :type => type, :combo => combo, :dbname => dbname, :dbpassword => dbpassword  }
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

  def app_boilers_create
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

    servicename = params[:servicename]
    if params[:bindedAPP] != "" && params[:bindedAPP] != "select an APP"
      bindedAPP = params[:bindedAPP].split(":")
      appname = bindedAPP[0].split("/")[1]
    related_components = bindedAPP[0]
    else
      appname = nil
      related_components = nil
    end

    if type == "postgresql"
      dbname = current_user.email
      dbpassword = ('0'..'z').to_a.shuffle.first(8).join
    end

    predef = GetPredefCloud.perform(params[:cloud], force_api[:email], force_api[:api_key])
    if predef.class == Megam::Error
      @err_msg="Please contact #{ActionController::Base.helpers.link_to 'support !.', "http://support.megam.co/"}."
      respond_to do |format|
        format.js {
          respond_with(@err_msg, :layout => !request.xhr? )
        }
      end
    else
      #if predef[0].spec[:type_name] == "docker"
      #  ttype = "tosca.docker."
      #else
        ttype = "tosca.web."
      #end

      options = {:assembly_name => assembly_name, :appname => appname, :servicename => servicename, :related_components => related_components, :component_version => version, :domain => domain, :cloud => cloud, :source => source, :ttype => ttype, :type => type, :combo => combo, :dbname => dbname, :dbpassword => dbpassword  }
      app_hash=MakeAssemblies.perform(options, force_api[:email], force_api[:api_key])
      @res = CreateAssemblies.perform(app_hash,force_api[:email], force_api[:api_key])
      if @res.class == Megam::Error
        @res_msg = nil
        @err_msg="Please contact #{ActionController::Base.helpers.link_to 'support !.', "http://support.megam.co/"}."
        respond_to do |format|
          format.js {
            respond_with(@res_msg, @err_msg, :layout => !request.xhr? )
          }
        end
      else
        if params[:bindedAPP] != "" && params[:bindedAPP] != "select an APP"
          bindedAPP = params[:bindedAPP].split(":")
          get_assembly = GetAssemblyWithoutComponentCollection.perform(bindedAPP[1], force_api[:email], force_api[:api_key])
          if get_assembly.class == Megam::Error
            @res_msg = nil
            @err_msg="Please contact #{ActionController::Base.helpers.link_to 'support !.', "http://support.megam.co/"}."
            respond_to do |format|
              format.js {
                respond_with(@res_msg, @err_msg, :layout => !request.xhr? )
              }
            end
          else
            get_component = GetComponent.perform(bindedAPP[2], force_api[:email], force_api[:api_key])
            if get_component.class == Megam::Error
              @res_msg = nil
              @err_msg="Please contact #{ActionController::Base.helpers.link_to 'support !.', "http://support.megam.co/"}."
              respond_to do |format|
                format.js {
                  respond_with(@res_msg, @err_msg, :layout => !request.xhr? )
                }
              end
            else
              relatedcomponent = assembly_name + "." + domain + "/" + servicename
              update_component_json = UpdateComponentJson.perform(get_component, relatedcomponent)
              update_component = UpdateComponent.perform(update_component_json, force_api[:email], force_api[:api_key])
              if update_component.class == Megam::Error
                @res_msg = nil
                @err_msg="Please contact #{ActionController::Base.helpers.link_to 'support !.', "http://support.megam.co/"}."
                respond_to do |format|
                  format.js {
                    respond_with(@res_msg, @err_msg, :layout => !request.xhr? )
                  }
                end
              else
                update_json = UpdateAssemblyJson.perform(get_assembly, get_component)
                update_assembly = UpdateAssembly.perform(update_json, force_api[:email], force_api[:api_key])
                if update_assembly.class == Megam::Error
                  @res_msg = nil
                  @err_msg="Please contact #{ActionController::Base.helpers.link_to 'support !.', "http://support.megam.co/"}."
                  respond_to do |format|
                    format.js {
                      respond_with(@res_msg, @err_msg, :layout => !request.xhr? )
                    }
                  end
                else
                  @err_msg = nil
                end
              end
            end
          end
        end
      end
    end
    @res_msg = "success"
    @err_msg = nil
  end

  def addons_create
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
    ttype = "tosca.web."
    appname = params[:appname]
    servicename = nil

    options = {:assembly_name => assembly_name, :appname => appname, :servicename => servicename, :component_version => version, :domain => domain, :cloud => cloud, :source => source, :ttype => ttype, :type => type, :combo => combo, :dbname => dbname, :dbpassword => dbpassword  }
    app_hash=MakeAssemblies.perform(options, force_api[:email], force_api[:api_key])
    @res = CreateAssemblies.perform(app_hash,force_api[:email], force_api[:api_key])
    if @res.class == Megam::Error
      @profile = "http://support.megam.co/"
      @err_msg= ActionController::Base.helpers.link_to 'Contact support', @profile
      respond_to do |format|
        format.js {
          respond_with(@err_msg, :layout => !request.xhr? )
        }
      end
    end
  end

end
class AddonsController < ApplicationController
  respond_to :html, :js
  include Packable
  def show
    breadcrumbs.add "Home", "#", :class => "fa fa-home", :target => "_self"
    breadcrumbs.add "MarketPlace", marketplaces_path, :target => "_self"
    @marketplace_id = params[:id]

    #the param[:id] actually has the full name as `1-DRBD`.
    #if the name doesn't exists then redirect to the selection screen.
    unless @marketplace_id
      redirect_to marketplace_path(:id => params[:id]), :gflash => { :warning => { :value => "Please select the addon again.", :sticky => false, :nodom_wrap => true } }
    else
      
      @addon_name = params[:name]
      
      @my_apps = []
      tmp_myapps = current_user.apps.order("id DESC").all
      if tmp_myapps.any?
        @my_apps = tmp_myapps.map {|c| c.name}
        @my_apps = @my_apps.uniq
      else
        @my_apps << "None"
      end
      render "addons/#{params[:name]}"
    end
  end

  def create
    logger.debug "--> Marketplace:Addon, #{params}"
    ## if the node_name is blank, then we may have to skip Finding it. This can happen where addons are configured but
    ## not attached to an app or service
    @addons_out ={}
    if params[:backuphost] && params[:backuphost] != "Choose an App/Service"
    	params[:fromhost] = params[:backuphost]
    	params[:tohosts] = [""]
    end
    if params[:node_name]
      wparams = {:node => "#{params[:node_name]}" }
      @nodes = FindNodeByName.perform(wparams,force_api[:email],force_api[:api_key])
      if @nodes.class == Megam::Error
        @addons_out[:error] = "error"
      else
        node = @nodes.lookup("#{wparams[:node]}")
        params[:node_id] ||=  node.id
      end
    end

    unless @addons_out[:error]
      packed_parms = packed("Meat::Addons",params)
      addons_result =  CreateMarketplaceAddons.perform(packed_parms, force_api[:email], force_api[:api_key])
      if @req.class == Megam::Error
        @addons_out[:error] = "error"
      else
        if addons_result.respond_to?(:map) 
          @addons_out[:success] = addons_result.map {|oneaddon_out| oneaddon_out.some_msg[:msg] }.join("\n")
         else 
           @addons_out[:success] = addons_result.some_msg[:msg] 
         end
      end
    end

    @addon_name = params[:addon_name]

    respond_to do |format|
      format.js {
        respond_with(@addon_out, @addon_name,:layout => !request.xhr? )
      }
    end
  end
end


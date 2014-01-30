class CloudIdentitiesController < ApplicationController
  respond_to :html, :js

  add_breadcrumb "Dashboard", :cloud_dashboards_path
  def index
  end

  def new_identity
    logger.debug ">>> Parms #{params}"
    logger.debug ">>> Parms data #{params[:data]}"

    tempparms = {:agent => "CloudIdentityAgent", :command => "listRealms", :message => "URL=http://nomansland.com REALM_NAME=temporealm"}


    @cloud_identity = current_user.cloud_identities.create(:account_name => params[:account_name], :url => "www.google.co.in")
    if @cloud_identity.save
      flash[:alert] = "Cloud_Identity created with account_name #{@cloud_identity.account_name}"
      respond_with(@cloud_identity, :layout => !request.xhr? )
    end
  end

  def go_identity

    add_breadcrumb "Cloud Identity", cloud_identity_path(current_user.id)
    add_breadcrumb params[:format], go_identity_path
    @cloud_identity = current_user.cloud_identities.find_by_account_name(params[:format])
    @products = Product.all
    @apps_item = current_user.apps_items

  end

  def federate
    cu = current_user
    user = {:who => cu.first_name, :api_token => cu.api_token, :type => cu.user_type }
    instance = {:client => "knife", :cloud => "ec2", :action => "create", :image => "ami-123", :group => "megam", :run_list => "role[openam]" }
    sum = {:user => user, :instance => instance }
    hash_all = sum.to_json
    logger.debug "Full JSON #{hash_all}"

    tempparms = {:agent => "CloudIdentityAgent", :command => "listRealms", :message => "URL=http://nomansland.com REALM_NAME=temporealm"}

    @identity_type = params[:identity_type]

    params.each do |key,value|
      logger.debug "#{key} : #{value}"
      if key.start_with?('product_')
        p_id = key.sub('product_', '')

        logger.debug "PID #{p_id}"
        @apps_item = current_user.apps_items.find_by_product_id(p_id)
        if !@apps_item.cloud_identity_id
          @apps_item.update_attributes(:app_name => value, :cloud_identity_id => params[:ci], :federated_identity_type => params[:identity_type])
        @apps_item.save
        else
          @identity = current_user.cloud_identities.find(params[:ci])
          @apps = @identity.apps_items.create(:app_name => value, :users_id => current_user.id, :product_id => p_id, :federated_identity_type => params[:identity_type] )
        @apps.save
        end

      end
    end
    @ci = current_user.cloud_identities.find(params[:ci])
    redirect_to go_identity_path(@ci.account_name), :gflash => { :success => { :value => "Your applications was federated in #{@ci.account_name}.", :sticky => false, :nodom_wrap => true } }
  end

  def create
    @cloud_identity = current_user.cloud_identities.create(params[:cloud_identity]) || CloudIdentity.new(params[:cloud_identity])

    if @cloud_identity.save
      flash[:success] = "Cloud Identity Created with #{current_user.organization.name}"
      #redirect_to users_show_url

      respond_to do |format|
        format.html { redirect_to users_show_url }
        format.js
      end
    end
  end

  def show
    add_breadcrumb "Cloud Identity", cloud_identity_path(current_user.id)
    @user = User.find(current_user.id)
    @products = Product.all
    @apps_item = current_user.apps_items
    @cloud_identity = current_user.cloud_identities.all

    if !@user.organization
       flash[:error] = "Update your organization in your profile. Why do we need it ? Read about it in our docs  #{ActionController::Base.helpers.link_to 'docs {}.', page_path('doc')}".html_safe
      redirect_to edit_user_path(current_user)
    end
  end

  def update
    sleep 10
    @cloud_identity=CloudIdentity.find(params[:id])
    if @cloud_identity.update_attributes(params[:cloud_identity])
      respond_with(@cloud_identity, :layout => !request.xhr? )
    end
  end

  def destroy
    sleep 1
    current_user.cloud_identities.find(params[:id]).destroy
    redirect_to dashboard_path(current_user.id)
  end
end

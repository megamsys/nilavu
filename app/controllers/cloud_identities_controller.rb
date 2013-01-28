#require 'ironfist_client'
class CloudIdentitiesController < ApplicationController
  respond_to :html, :js

  add_breadcrumb "Home", :root_path
  add_breadcrumb "Dashboard", :dashboard_path
  def index
  end

  def new_identity
    #@ironclient = Ironclient.new
    sleep 1
    logger.debug ">>> Parms #{params}"
    logger.debug ">>> Parms data #{params[:data]}"

    ir = IronfistClient.new
    tempparms = {:agent => "CloudIdentityAgent", :command => "listRealms", :message => "URL=http://nomansland.com REALM_NAME=temporealm"}

    #ir.pub_and_wait(Ironfist::Init.instance.connection, tempparms,0) do |resp|
    # puts "result #{resp}"
    #end

    ir.fake
    @cloud_identity = current_user.cloud_identities.create(:account_name => params[:account_name], :url => "www.google.co.in")

    #random_token = p SecureRandom.urlsafe_base64(nil, true)
    #current_user.cloud_identities.update_attribute(:api_token, random_token)

    respond_with(@cloud_identity, :layout => !request.xhr? )
  end

  def federate
    cu = current_user
    user = {:who => cu.first_name, :api_token => cu.api_token, :type => cu.user_type }

    instance = {:client => "knife", :cloud => "ec2", :action => "create", :image => "ami-123", :group => "megam", :run_list => "role[openam]" }

    sum = {:user => user, :instance => instance }
    hash_all = sum.to_json
    logger.debug "Full JSON #{hash_all}"
    #cu.cloud_run.new

    #@cloud_run = cu.cloud_runs.build(:name => "Run Name", :status => "running", :description => hash_all)
    #@cloud_run.save

    #@ironclient = Ironclient.new
    ir = IronfistClient.new
    tempparms = {:agent => "CloudIdentityAgent", :command => "listRealms", :message => "URL=http://nomansland.com REALM_NAME=temporealm"}

    ir.fake
    #@cloud_identity = current_user.cloud_identities(current_user.id)
    @identity_type = params[:identity_type]
    #respond_with(@identity_type ,:layout => !request.xhr? )

    params.each do |key,value|
      logger.debug "#{key} : #{value}"
      if key.start_with?('product_')
        p_id = key.sub('product_', '')
        @identity_app = current_user.apps_items.find(p_id)
        @identity_app.update_attribute(:app_name, value)
      @identity_app.save
      end
    end

    redirect_to cloud_identity_path(current_user.id)
  end

  def create
    @cloud_identity = current_user.build_cloud_identities(params[:cloud_identity]) || CloudIdentity.new(params[:cloud_identity])

    if @cloud_identity.save
      flash[:success] = "Cloud Identity Created with #{current_user.organization.account_name}"
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
      flash[:error] = "Please Create Organization Details first"
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
    current_user.cloud_identities.find(params[:id]).destroy
    flash[:success] = "Cloud_identity #{current_user.cloud_identities.account_name} destroyed."
    redirect_to users_show_url
  end
end

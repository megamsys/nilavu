#require 'ironfist_client'
class CloudIdentitiesController < ApplicationController
  respond_to :html, :js

  add_breadcrumb "Home", :root_path
  add_breadcrumb "Dashboard", :dashboard_path
  def index
  end

  def new
    #@ironclient = Ironclient.new
    ir = IronfistClient.new
    tempparms = {:agent => "CloudIdentityAgent", :command => "listRealms", :message => "URL=http://nomansland.com REALM_NAME=temporealm"}

    #ir.pub_and_wait(Ironfist::Init.instance.connection, tempparms,0) do |resp|
    # puts "result #{resp}"
    #end

    ir.fake
    @cloud_identity = current_user.build_cloud_identities

    #random_token = p SecureRandom.urlsafe_base64(nil, true)
    #current_user.cloud_identities.update_attribute(:api_token, random_token)

    respond_with(@cloud_identity, :layout => !request.xhr? )
  end

  def federate
    logger.debug "federate identity -> #{params[:identity_type]}"

    cu = current_user
    user = {:who => cu.first_name, :api_token => cu.api_token, :type => cu.user_type, :account_name => cu.cloud_identities.account_name }

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
    @cloud_identity = current_user.build_cloud_identities
    @identity_type = params[:identity_type]
    respond_with(@cloud_identity, @identity_type ,:layout => !request.xhr? )
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
    @user = User.find(params[:id])
    @products = Product.all
    @apps_item = current_user.apps_items

    if !@user.organization
      flash[:error] = "Please Create Organization Details first"
      redirect_to edit_user_path(current_user)
    end

    #For Account_Name
    @name = current_user.organization.name.gsub(/[^0-9A-Za-z]/, '')
    @name = @name.gsub(" ", "")
    if @name.length > 10
    acc_name = @name.slice(0,10)
    else
    acc_name = @name
    end

    @user.cloud_identities.create(:account_name => acc_name)
    @cloud_identity = @user.cloud_identities.last
  end

  def update
      sleep 10
    @cloud_identity=CloudIdentity.find(params[:id])
    if @cloud_identity.update_attributes(params[:cloud_identity])
      respond_with(@cloud_identity, :layout => !request.xhr? )
    end
  end

  def destroy
    CloudIdentity.find(params[:id]).destroy
    flash[:success] = "Cloud_identity #{current_user.organization.account_name} destroyed."
    redirect_to users_show_url
  end
end

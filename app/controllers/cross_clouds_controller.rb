class CrossCloudsController < ApplicationController
  respond_to :html, :js
  include CrossCloudsHelper
  def new
        keys = list_sshkeys
        unless keys.nil?
      respond_to do |format|
        format.js {
          respond_with(@ssh_keys, :layout => !request.xhr? )
        }
      end
        else
        @err_msg = "Create a ssh_key first"
        @ssh_keys = keys
                #redirect_to settings_path, :alert => "Please create a ssh key"
                      respond_to do |format|
        format.js {
          respond_with(keys, @err_msg, :layout => !request.xhr? )
        }
        end
end
  end

  def create
    logger.debug "CROSS CLOUD CREATE PARAMS ============> "
if Rails.configuration.storage_type == "s3"
    vault_loc = vault_base_url+"/"+current_user.email+"/"+params[:name]
    sshpub_loc = vault_base_url+"/"+current_user.email+"/"+params[:id_rsa_public_key]
else
     vault_loc = current_user.email+"_"+params[:name]
    sshpub_loc = current_user.email+"_"+params[:id_rsa_public_key]    #Riak changes
end
    #private_key = (params[:private_key]) ? cross_cloud_bucket+"/"+current_user.email+"/"+params[:name]+"/"+File.basename(params[:private_key]) : ""
    if params[:provider] != "profitbricks"
      #private_key = ((params[:private_key].original_filename).length > 0) ? cross_cloud_bucket+"/"+current_user.email+"/"+params[:name]+"/"+params[:private_key].original_filename : ""
      wparams = {:name => params[:name], :spec => { :type_name => get_provider_value(params[:provider]), :groups => params[:group],  :image => params[:image].split(',').last.partition(':').last, :flavor => params[:flavor].split(',').last.partition(':').last, :tenant_id => params[:tenant_id]}, :access => { :ssh_key => params[:ssh_key], :identity_file => sshpub_loc, :ssh_user => params[:ssh_user], :vault_location => vault_loc, :sshpub_location => sshpub_loc, :zone => params[:zone], :region => params[:region] }  }
    else
      wparams = {:name => params[:name], :spec => { :type_name => get_provider_value(params[:provider]), :groups => params[:group],  :image => params[:image].split(',').last.partition(':').last, :flavor => params[:flavor].split(',').last.partition(':').last, :tenant_id => params[:tenant_id]}, :access => { :ssh_key => params[:ssh_key], :identity_file => "", :ssh_user => params[:ssh_user], :vault_location => vault_loc, :sshpub_location => sshpub_loc, :zone => params[:zone], :region => params[:region] }  }
    end

    if params[:provider] == "profitbricks"
        #Profitbricks flavor parsing has to be decided yet
      wparams[:spec][:flavor] = "cpus=#{params[:cpus]},ram=#{params[:ram]},hdd-size=#{params[:flavor]}"
    end
    if params[:provider] == "GoGrid"
      wparams[:access][:zone] = get_gogrid_ip(params[:api_key], params[:shared_secret], params[:datacenter])
    end
    @res_body = CreatePredefClouds.perform(wparams,force_api[:email], force_api[:api_key])
    if @res_body.class == Megam::Error
      @res_msg = nil
      #@err_msg="Please contact #{ActionController::Base.helpers.link_to 'support !.', "http://support.megam.co/"}."
        @err_msg="Sorry, Cloud creation failed"
      respond_to do |format|
        format.js {
          respond_with(@res_msg, @err_msg, :layout => !request.xhr? )
        }
      end
    else
      @err_msg = nil
      if params[:provider] == "Amazon EC2"
        upload_options = {:email => current_user.email, :name => params[:name], :private_key => params[:private_key], :aws_access_key => params[:aws_access_key], :aws_secret_key => params[:aws_secret_key], :type => cc_type(params[:provider])}
        @upload = AmazonCloud.perform(upload_options, cross_cloud_bucket)
      end
      if params[:provider] == "hp cloud"
        upload_options = {:email => current_user.email, :name => params[:name], :private_key => params[:private_key], :hp_access_key => params[:hp_access_key], :hp_secret_key => params[:hp_secret_key], :type => cc_type(params[:provider])}
        @upload = HpCloud.perform(upload_options, cross_cloud_bucket)
      end

      if params[:provider] == "profitbricks"
        upload_options = {:email => current_user.email, :name => params[:name], :private_key => params[:private_key], :profitbricks_username => params[:profitbricks_username], :profitbricks_password => params[:profitbricks_password], :type => cc_type(params[:provider]), :id_rsa_public_key => params[:id_rsa_public_key]}
        @upload = ProfitbricksCloud.perform(upload_options, cross_cloud_bucket)
      end

      if params[:provider] == "opennebula"
        upload_options = {:email => current_user.email, :name => params[:name], :private_key => params[:private_key], :opennebula_username => params[:opennebula_username], :opennebula_password => params[:opennebula_password], :type => cc_type(params[:provider])}
        @upload = OpennebulaCloud.perform(upload_options, cross_cloud_bucket)
      end

      if params[:provider] == "Google Compute Engine"
        if params[:access_token].length > 0
          @data = CreateGoogleJSON.perform(params[:access_token], params[:refresh_token], params[:expire], params[:project_name], params[:google_client_id], params[:google_secret_key])
        end
        upload_options = {:email => current_user.email, :name => params[:name], :provider_value => get_provider_value(params[:provider]), :type => cc_type(params[:provider]), :g_json => @data}
        @upload = GoogleCloud.perform(upload_options, cross_cloud_bucket)
      end

      if params[:provider] == "GoGrid"
        upload_options = {:email => current_user.email, :name => params[:name], :api_key => params[:api_key], :shared_secret => params[:shared_secret], :type => cc_type(params[:provider]) }
        @upload = Gogrid.perform(upload_options, cross_cloud_bucket)
      end

      if @upload.class == Megam::Error
        @res_msg = nil
        @err_msg="Failed to upload cross cloud files."
        respond_to do |format|
          format.js {
            respond_with(@res_msg, @err_msg, :layout => !request.xhr? )
          }
        end
      else
        @res_msg= "Cross cloud defintion :"+ params[:name] + " created successfully."
        respond_to do |format|
          format.js {
            respond_with(@res_msg, @err_msg, :layout => !request.xhr? )
          }
        end
      end
    end
  #redirect_to cross_clouds_path, :gflash => { :warning => { :value => "CROSS  CLOUD CREATION DONE ", :sticky => false, :nodom_wrap => true } }

  end

  def cloud_selector
    list_sshkeys
    @provider = params[:cloud]
    if params[:cloud] == "aws"
      @provider_form_name = "Amazon EC2"
        list_aws_data(params[:aws_access_key], params[:aws_secret_key], params[:region])
        @images = @aws_imgs
        @flavors = @aws_flavors
        @keypairs = @aws_keypairs
        @groups = @aws_groups
        @credentials = {"aws_access_key" => "#{params[:aws_access_key]}", "aws_secret_key" => "#{params[:aws_secret_key]}", "region" => "#{params[:region]}"}

    elsif params[:cloud] == "hp"
      @provider_form_name = "hp cloud"
        list_hp_data(params[:hp_access_key], params[:hp_secret_key], params[:tenant_id], params[:region])
        @images = @hp_imgs
        @flavors = @hp_flavors
        @keypairs = @hp_keypairs
        @groups = []
        @credentials = {"hp_access_key" => "#{params[:hp_access_key]}", "hp_secret_key" => "#{params[:hp_secret_key]}", "tenant_id" => "#{params[:tenant_id]}", "region" => "#{params[:region]}"}

    elsif params[:cloud] == "gce"
      @provider_form_name = "Google Compute Engine"
    elsif params[:cloud] == "profitbricks"
      @provider_form_name = "profitbricks"
    elsif params[:cloud] == "gogrid"
      @provider_form_name = "GoGrid"
    elsif params[:cloud] == "opennebula"
      @provider_form_name = "opennebula"
    else
      @provider_form_name = "Amazon EC2"
    end
    respond_to do |format|
      format.js {
        respond_with(@provider, @provider_form_name, @credentials, @images, @flavors, @keypairs, @groups, @ssh_keys, :layout => !request.xhr? )
      }
      format.html {
        redirect_to new_cross_cloud_path
      }
    end
  end


  def list_sshkeys
    logger.debug "--> #{self.class} : list sshkeys entry"
    @ssh_keys_collection = ListSshKeys.perform(force_api[:email], force_api[:api_key])
    logger.debug "--> #{self.class} : listed sshkeys"

    if @ssh_keys_collection.class != Megam::Error
      @ssh_keys = []
      ssh_keys = []
      @ssh_keys_collection.each do |sshkey|
        ssh_keys << {:name => sshkey.name, :created_at => sshkey.created_at.to_time.to_formatted_s(:rfc822)}
      end
      @ssh_keys = ssh_keys.sort_by {|vn| vn[:created_at]}
    end
  end

  def get_gogrid_ip(api_key, shared_secret, datacenter)
    connection = Fog::Compute::GoGrid.new(
    :go_grid_api_key => api_key,
    :go_grid_shared_secret => shared_secret
    )
    options = {:datacenter => datacenter}
    ip_list_collection1 = connection.grid_ip_list(options)
    ip_list_collection = ip_list_collection1.data[:body]["list"]
    iplist = []
    ip_list_collection.each do |ip_list|
      if ip_list["state"]["name"] == "Unassigned" && ip_list["public"] == true
        iplist << ip_list["ip"]
      end
    end
    iplist[0]
  end

end

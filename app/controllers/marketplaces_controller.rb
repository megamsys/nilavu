##
## Copyright [2013-2015] [Megam Systems]
##
## Licensed under the Apache License, Version 2.0 (the "License");
## you may not use this file except in compliance with the License.
## You may obtain a copy of the License at
##
## http://www.apache.org/licenses/LICENSE-2.0
##
## Unless required by applicable law or agreed to in writing, software
## distributed under the License is distributed on an "AS IS" BASIS,
## WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
## See the License for the specific language governing permissions and
## limitations under the License.
##
require 'json'

class MarketplacesController < ApplicationController
  respond_to :js
  include MarketplaceHelper
  include AppsHelper
  include CrossCloudsHelper
  ##
  ## index page get all marketplace items from storage(we use riak) using megam_gateway
  ## and show the items in order of category
  ##
  def index
    if user_in_cookie?
      mkp = get_marketplaces

      @mkp_collection = mkp[:mkp_collection]
      if @mkp_collection.class == Megam::Error
        redirect_to main_dashboards_path, :gflash => { :warning => { :value => "API server may be down. Please contact #{ActionController::Base.helpers.link_to 'support !.', "http://support.megam.co/", :target => "_blank"}.", :sticky => false, :nodom_wrap => true } }
      else
        @categories=[]
        @order=[]
        @order = @mkp_collection.map {|c|
      c.name
      }
        @order = @order.sort_by {|elt| ary = elt.split("-").map(&:to_i); ary[0] + ary[1]}
        @categories = @mkp_collection.map {|c| c.appdetails[:category]}
        @categories = @categories.uniq

      end
    else
      redirect_to signin_path
    end
  end

  ##
  ## to show the selected marketplace item
  ##
  def show
    if user_in_cookie?
      bill_collection = GetBalance.perform(force_api[:email], force_api[:api_key])
      case 
      when bill_collection.class == Megam::Error
        logger.debug "--> #{self.class} : Get user balances got error"
        respond_to do |format|
          format.html {redirect_to billings_path}
          format.js {render :js => "window.location.href='"+billings_path+"'"}
        end
      when bill_collection.class != Megam::Error
        logger.debug "--> #{self.class} : Got user balance"
        bill = bill_collection.lookup(force_api[:email])
        if bill.credit.to_i <= 0
          respond_to do |format|
            format.html {redirect_to billings_path}
            format.js {render :js => "window.location.href='"+billings_path+"'"}
          end
        else
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

            respond_to do |format|
              format.js {
                respond_with(@mkp, @version_order, @type, @ssh_keys, :layout => !request.xhr? )
              }
            end
          end
        end
      end
    else
      redirect_to signin_path
    end
  end

  ##
  ## get all assemblies(it means applications) for that user launched and
  ## list the applications in dashboard
  ##
  def get_apps
    apps = []
    if user_in_cookie?
      @user_id = current_user.email
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

=begin
def authorize_scm
logger.debug "CloudBooks:authorize_scm, entry"
auth_token = request.env['omniauth.auth']['credentials']['token']
github = Github.new oauth_token: auth_token
git_array = github.repos.all.collect { |repo| repo.clone_url }
@repos = git_array
render :template => "apps/new", :locals => {:repos => @repos}

#session[:info] = request.env['omniauth.auth']['credentials']
auth_token = request.env['omniauth.auth']['credentials']['token']
github = Github.new oauth_token: auth_token
git_array = github.repos.all.collect { |repo| repo.clone_url }
@repos = git_array

# @repos
end

=end

  ##
  ## after finish the github authentication the callback url comes this method
  ## this function parse the request and get the github credentials
  ## and store that credentials to session
  ##
  def github_scm
    if current_user.nil?
      redirect_to :controller=>'sessions', :action=>'create'
    else
      @auth_token = request.env['omniauth.auth']['credentials']['token']
      session[:github] =  @auth_token
      session[:git_owner] = request.env['omniauth.auth']['extra']['raw_info']['login']
    end
  end

  ##
  ## this method collect all repositories for user using oauth token
  ##
  def github_sessions
    auth_id = params['id']
    github = Github.new oauth_token: auth_id
    git_array = github.repos.all.collect { |repo| repo.clone_url }
    @repos = git_array
    respond_to do |format|
      format.js {
        respond_with(@repos, :layout => !request.xhr? )
      }
    end
  end

  ##
  ## get session data and sends to UI
  ##
  def github_sessions_data
    @tokens_gh = session[:github]
    render :text => @tokens_gh
  end

  def gogs
  end

  ##
  ## gogswindow html page method
  ##
  def gogswindow
  end

  ##
  ## get the repositories from session
  ## SCRP: What happens if gogs fails.
  def gogs_sessions
    @repos = session[:gogs_repos]
    respond_to do |format|
      format.js {
        respond_with(@repos, :layout => !request.xhr? )
      }
    end
  end

  ##
  ## this function get the gogs token using username and password
  ## then list the repositories using oauth tokens.
  ## SCRP: There is no error trap here. What happens if gogs fails ?
  def gogs_return
    session[:gogs_owner] = params[:gogs_username]
    tokens = ListGogsTokens.perform(params[:gogs_username], params[:gogs_password])
    session[:gogs_token] = JSON.parse(tokens)[0]["sha1"]
    @gogs_repos = ListGogsRepo.perform(token)
    obj_repo = JSON.parse(@gogs_repos)
    @repos_arr = []
    obj_repo.each do |one_repo|
      @repos_arr << one_repo["clone_url"]
    end
    session[:gogs_repos] =  @repos_arr
  end

  ##
  ## user clicks the particular marketplace item then this controller collect the details of
  ## that selected item and show the contents
  ##
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

  ##
  ## this controller collect all registered marketplace items from megam storage
  ##
  def get_marketplaces
    if user_in_cookie?
      mkp_collection = ListMarketPlaceApps.perform(force_api[:email], force_api[:api_key])
      {:mkp_collection => mkp_collection}
    else
      redirect_to signin_path
    end
  end

  ##
  ## when change the version of marketplace item then this controller change the contents of that item
  ##
  def changeversion
    if user_in_cookie?
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
    else
      redirect_to signin_path
    end
  end

  ##
  ## this controller launch the instances(which means virtual machines)
  ## this performs three types of condition operations for launching instances using sshkeys
  ##
  def instances_create
    if user_in_cookie?
      assembly_name = params[:name]
      version = params[:version]
      domain = params[:domain]
      cloud = params[:cloud]
      source = params[:source]
      type = params[:type].downcase
      sshoption = params[:sshoption]

      dbname = nil
      dbpassword = nil

      combos = params[:combos]
      combo = combos.split("+")

      ttype = "tosca.web."
      appname = params[:appname]
      servicename = nil
      sshkeyname = nil
      logger.debug "--> #{self.class} : Instance creation - I'm in..."
      ## check the user chose what type of ssh option and then perform it
      ## in this case we have three options
      ## first  - create option then we create a new ssh key for user
      ## second - user already have ssh keys and upload it
      ## third  - user already create and upload sshkeys on megam storage
      ## finally set the sshkeys and launch the instance
      if sshoption == "CREATE"
        k = SSHKey.generate
        key_name = params[:sshcreatename] + "_" + assembly_name || current_user.first_name
        sshkeyname = key_name
        filename = key_name
        if Rails.configuration.storage_type == "s3"
          sshpub_loc = vault_s3_url+"/"+current_user.email+"/"+key_name
        else
          sshpub_loc = current_user.email+"_"+key_name     #Riak changes
        end
        wparams = { :name => key_name, :path => sshpub_loc }
        res_body = CreateSshKeys.perform(wparams, force_api[:email], force_api[:api_key])
        if res_body.class == Megam::Error
          res_msg = nil
          err_msg="Please contact #{ActionController::Base.helpers.link_to 'support !.', "http://support.megam.co/"}."
          respond_to do |format|
            format.js {
              respond_with(res_msg, err_msg, filename, :layout => !request.xhr? )
            }
          end
        else
          logger.debug "--> #{self.class} : Instance creation - ssh key creating..."
          err_msg = nil
          options ={:email => current_user.email, :ssh_key_name => key_name, :ssh_private_key => k.private_key, :ssh_public_key => k.ssh_public_key }
          upload = SshKey.perform(options, ssh_files_bucket)
          if upload.class == Megam::Error
            res_msg = nil
            err_msg="SSH key #{key_name} creation failed."
            public_key = ""
            respond_to do |format|
              format.js {
                respond_with(res_msg, err_msg, filename, :layout => !request.xhr? )
              }
            end
          end
          logger.debug "--> #{self.class} : Instance creation - ssh key created..."
        end
      end

      if sshoption == "UPLOAD"
        filename = params[:key_name]
        key_name = params[:sshuploadname] + "_" + assembly_name
        sshkeyname = key_name
        if Rails.configuration.storage_type == "s3"
          sshpub_loc = vault_s3_url+"/"+current_user.email+"/"+key_name
        else
          sshpub_loc = current_user.email+"_"+key_name     #Riak changes
        end
        wparams = { :name => key_name, :path => sshpub_loc }
        res_body = CreateSshKeys.perform(wparams, force_api[:email], force_api[:api_key])
        if res_body.class == Megam::Error
          res_msg = nil
          err_msg="Please contact #{ActionController::Base.helpers.link_to 'support !.', "http://support.megam.co/"}."
          respond_to do |format|
            format.js {
              respond_with(res_msg, err_msg, filename, :layout => !request.xhr? )
            }
          end
        else
          logger.debug "--> #{self.class} : Instance creation - ssh key uploading..."
          err_msg = nil
          options ={:email => current_user.email, :ssh_key_name => key_name, :ssh_private_key => params[:ssh_private_key], :ssh_public_key => params[:ssh_public_key] }
          upload = SshKey.upload(options, ssh_files_bucket)
          if upload.class == Megam::Error
            res_msg = nil
            err_msg="Failed to Generate SSH keys. Please contact #{ActionController::Base.helpers.link_to 'support !.', "http://support.megam.co/"}."
            public_key = ""
            respond_to do |format|
              format.js {
                respond_with(res_msg, err_msg, filename, :layout => !request.xhr? )
              }
            end
          end
          logger.debug "--> #{self.class} : Instance creation - sshkey uploaded..."
        end
      end

      if sshoption == "EXIST"
        sshkeyname = params[:sshexistname]
      end

      logger.debug "--> #{self.class} : Instance creation - Instance launching..."
      options = {:instance => true, :assembly_name => assembly_name, :appname => appname, :servicename => servicename, :component_version => version, :domain => domain, :cloud => cloud, :source => source, :ttype => ttype, :type => type, :combo => combo, :dbname => dbname, :dbpassword => dbpassword, :sshkeyname => sshkeyname  }
      app_hash=MakeAssemblies.perform(options, force_api[:email], force_api[:api_key])
      res = CreateAssemblies.perform(app_hash,force_api[:email], force_api[:api_key])
      if res.class == Megam::Error
        err_msg="Please contact #{ActionController::Base.helpers.link_to 'support !.', "http://support.megam.co/"}."
        respond_to do |format|
          format.js {
            respond_with(err_msg, :layout => !request.xhr? )
          }
        end
      end
      logger.debug "--> #{self.class} : Instance creation - Instance launched successfully..."
    end
  end

  ##
  ## this controller launch the starters pack(megam provide these packages)
  ##
  def starter_packs_create
    if user_in_cookie?
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
      puts combo.inspect

      appname = params[:appname]
      servicename = params[:servicename]

      predef = GetPredefCloud.perform(params[:cloud], force_api[:email], force_api[:api_key])
      if predef.class == Megam::Error
        err_msg="Please contact #{ActionController::Base.helpers.link_to 'support !.', "http://support.megam.co/"}."
        respond_to do |format|
          format.js {
            respond_with(err_msg, :layout => !request.xhr? )
          }
        end
      else
      # if predef[0].spec[:type_name] == "docker"
      # ttype = "tosca.docker."
      # else
        ttype = "tosca.web."
        #end

        options = {:instance => false, :assembly_name => assembly_name, :appname => appname, :servicename => servicename, :component_version => version, :domain => domain, :cloud => cloud, :source => source, :ttype => ttype, :type => type, :combo => combo, :dbname => dbname, :dbpassword => dbpassword  }
        app_hash=MakeAssemblies.perform(options, force_api[:email], force_api[:api_key])
        res = CreateAssemblies.perform(app_hash,force_api[:email], force_api[:api_key])
        if res.class == Megam::Error
          err_msg="Please contact #{ActionController::Base.helpers.link_to 'support !.', "http://support.megam.co/"}."
          respond_to do |format|
            format.js {
              respond_with(err_msg, :layout => !request.xhr? )
            }
          end
        end
      end
    else
      redirect_to signin_path
    end
  end

  ##
  ## this controller launch the services
  ## it checks service is bind any of the applications, the service is bind to application then add the application name to inputs
  ##
  def app_boilers_create
    if user_in_cookie?
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
        err_msg="Please contact #{ActionController::Base.helpers.link_to 'support !.', "http://support.megam.co/"}."
        respond_to do |format|
          format.js {
            respond_with(err_msg, :layout => !request.xhr? )
          }
        end
      else
      #if predef[0].spec[:type_name] == "docker"
      #  ttype = "tosca.docker."
      #else
        ttype = "tosca.web."
        #end

        options = {:instance => false, :assembly_name => assembly_name, :appname => appname, :servicename => servicename, :related_components => related_components, :component_version => version, :domain => domain, :cloud => cloud, :source => source, :ttype => ttype, :type => type, :combo => combo, :dbname => dbname, :dbpassword => dbpassword  }
        app_hash=MakeAssemblies.perform(options, force_api[:email], force_api[:api_key])
        res = CreateAssemblies.perform(app_hash,force_api[:email], force_api[:api_key])
        if res.class == Megam::Error
          res_msg = nil
          err_msg="Please contact #{ActionController::Base.helpers.link_to 'support !.', "http://support.megam.co/"}."
          respond_to do |format|
            format.js {
              respond_with(res_msg, err_msg, :layout => !request.xhr? )
            }
          end
        else
          if params[:bindedAPP] != "" && params[:bindedAPP] != "select an APP"
            bindedAPP = params[:bindedAPP].split(":")
            get_assembly = GetAssemblyWithoutComponentCollection.perform(bindedAPP[1], force_api[:email], force_api[:api_key])
            if get_assembly.class == Megam::Error
              res_msg = nil
              err_msg="Please contact #{ActionController::Base.helpers.link_to 'support !.', "http://support.megam.co/"}."
              respond_to do |format|
                format.js {
                  respond_with(res_msg, err_msg, :layout => !request.xhr? )
                }
              end
            else
              get_component = GetComponent.perform(bindedAPP[2], force_api[:email], force_api[:api_key])
              if get_component.class == Megam::Error
                res_msg = nil
                err_msg="Please contact #{ActionController::Base.helpers.link_to 'support !.', "http://support.megam.co/"}."
                respond_to do |format|
                  format.js {
                    respond_with(res_msg, err_msg, :layout => !request.xhr? )
                  }
                end
              else
                relatedcomponent = assembly_name + "." + domain + "/" + servicename
                update_component_json = UpdateComponentJson.perform(get_component, relatedcomponent)
                update_component = UpdateComponent.perform(update_component_json, force_api[:email], force_api[:api_key])
                if update_component.class == Megam::Error
                  res_msg = nil
                  err_msg="Please contact #{ActionController::Base.helpers.link_to 'support !.', "http://support.megam.co/"}."
                  respond_to do |format|
                    format.js {
                      respond_with(res_msg, err_msg, :layout => !request.xhr? )
                    }
                  end
                else
                  update_json = UpdateAssemblyJson.perform(get_assembly, get_component)
                  update_assembly = UpdateAssembly.perform(update_json, force_api[:email], force_api[:api_key])
                  if update_assembly.class == Megam::Error
                    res_msg = nil
                    err_msg="Please contact #{ActionController::Base.helpers.link_to 'support !.', "http://support.megam.co/"}."
                    respond_to do |format|
                      format.js {
                        respond_with(res_msg, err_msg, :layout => !request.xhr? )
                      }
                    end
                  else
                    err_msg = nil
                  end
                end
              end
            end
          end
        end
      end
      res_msg = "success"
      err_msg = nil
    else
      redirect_to signin_path
    end
  end

  ##
  ## this controller launch the addons
  ##
  def addons_create
    if user_in_cookie?
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

      options = {:instance => false, :assembly_name => assembly_name, :appname => appname, :servicename => servicename, :component_version => version, :domain => domain, :cloud => cloud, :source => source, :ttype => ttype, :type => type, :combo => combo, :dbname => dbname, :dbpassword => dbpassword  }
      app_hash=MakeAssemblies.perform(options, force_api[:email], force_api[:api_key])
      res = CreateAssemblies.perform(app_hash,force_api[:email], force_api[:api_key])
      if res.class == Megam::Error
        profile = "http://support.megam.co/"
        err_msg= ActionController::Base.helpers.link_to 'Contact support', profile
        respond_to do |format|
          format.js {
            respond_with(err_msg, :layout => !request.xhr? )
          }
        end
      end
    else
      redirect_to signin_path
    end
  end

  ##
  ## byoc means bring your own code
  ## this option the users put their project from scm(github, gogs...)
  ## then launch the application to cloud
  ##
  def byoc_create
    assembly_name = params[:name]

    version = params[:version]
    domain = params[:domain]
    cloud = params[:cloud]
    #app_type = params[:byoc]
    source = params[:source]
    sshoption = params[:sshoption]

    type = params[:byoc].downcase

    dbname = nil
    dbpassword = nil
    combo = []
    combo << params[:byoc].downcase

    ttype = "tosca.web."
    appname = params[:appname]
    servicename = nil

    if params[:scm_name] == "github"
      scmtoken =  session[:github]
      scmowner =  session[:git_owner]
    elsif params[:scm_name] == "gogs"
      scmtoken =  session[:gogs_token]
      scmowner =  session[:gogs_owner]
    else
      scmtoken =  ""
      scmowner =  ""
    end

    if params[:check_ci] == "true"
      options = {:instance => false, :assembly_name => assembly_name, :appname => appname, :servicename => servicename, :component_version => version, :domain => domain, :cloud => cloud, :source => source, :ttype => ttype, :type => type, :combo => combo, :dbname => dbname, :dbpassword => dbpassword, :ci => true, :scm_name => params[:scm_name], :scm_token =>  scmtoken, :scm_owner => scmowner }
    else
    #options = {:assembly_name => assembly_name, :appname => appname, :servicename => servicename, :component_version => version, :domain => domain, :cloud => cloud, :source => source, :ttype => ttype, :type => type, :combo => combo, :dbname => dbname, :dbpassword => dbpassword, :ci => false, :scm_name => params[:scm_name], :scm_token =>  scmtoken, :scm_owner => scmowner   }
      options = {:instance => false, :assembly_name => assembly_name, :appname => appname, :servicename => servicename, :component_version => version, :domain => domain, :cloud => cloud, :source => source, :ttype => ttype, :type => type, :combo => combo, :dbname => dbname, :dbpassword => dbpassword, :ci => true, :scm_name => params[:scm_name], :scm_token =>  scmtoken, :scm_owner => scmowner }
    end
    if sshoption == "CREATE"
      k = SSHKey.generate
      key_name = params[:sshcreatename] + "_" + assembly_name || current_user.first_name
      sshkeyname = key_name
      filename = key_name
      if Rails.configuration.storage_type == "s3"
        sshpub_loc = vault_s3_url+"/"+current_user.email+"/"+key_name
      else
        sshpub_loc = current_user.email+"_"+key_name     #Riak changes
      end
      wparams = { :name => key_name, :path => sshpub_loc }
      res_body = CreateSshKeys.perform(wparams, force_api[:email], force_api[:api_key])
      if res_body.class == Megam::Error
        res_msg = nil
        err_msg="Please contact #{ActionController::Base.helpers.link_to 'support !.', "http://support.megam.co/"}."
        respond_to do |format|
          format.js {
            respond_with(res_msg, err_msg, filename, :layout => !request.xhr? )
          }
        end
      else
        logger.debug "--> #{self.class} : Instance creation - ssh key creating..."
        err_msg = nil
        options ={:email => current_user.email, :ssh_key_name => key_name, :ssh_private_key => k.private_key, :ssh_public_key => k.ssh_public_key }
        upload = SshKey.perform(options, ssh_files_bucket)
        if upload.class == Megam::Error
          res_msg = nil
          err_msg="SSH key #{key_name} creation failed."
          public_key = ""
          respond_to do |format|
            format.js {
              respond_with(res_msg, err_msg, filename, :layout => !request.xhr? )
            }
          end
        end
        logger.debug "--> #{self.class} : Instance creation - ssh key created..."
      end
    end

    if sshoption == "UPLOAD"
      filename = params[:key_name]
      key_name = params[:sshuploadname] + "_" + assembly_name
      sshkeyname = key_name
      if Rails.configuration.storage_type == "s3"
        sshpub_loc = vault_s3_url+"/"+current_user.email+"/"+key_name
      else
        sshpub_loc = current_user.email+"_"+key_name     #Riak changes
      end
      wparams = { :name => key_name, :path => sshpub_loc }
      res_body = CreateSshKeys.perform(wparams, force_api[:email], force_api[:api_key])
      if res_body.class == Megam::Error
        res_msg = nil
        err_msg="Please contact #{ActionController::Base.helpers.link_to 'support !.', "http://support.megam.co/"}."
        respond_to do |format|
          format.js {
            respond_with(res_msg, err_msg, filename, :layout => !request.xhr? )
          }
        end
      else
        logger.debug "--> #{self.class} : Instance creation - ssh key uploading..."
        err_msg = nil
        options ={:email => current_user.email, :ssh_key_name => key_name, :ssh_private_key => params[:ssh_private_key], :ssh_public_key => params[:ssh_public_key] }
        upload = SshKey.upload(options, ssh_files_bucket)
        if upload.class == Megam::Error
          res_msg = nil
          err_msg="Failed to Generate SSH keys. Please contact #{ActionController::Base.helpers.link_to 'support !.', "http://support.megam.co/"}."
          public_key = ""
          respond_to do |format|
            format.js {
              respond_with(res_msg, err_msg, filename, :layout => !request.xhr? )
            }
          end
        end
        logger.debug "--> #{self.class} : Instance creation - sshkey uploaded..."
      end
    end

    if sshoption == "EXIST"
      sshkeyname = params[:sshexistname]
    end

    app_hash=MakeAssemblies.perform(options, force_api[:email], force_api[:api_key])
    res = CreateAssemblies.perform(app_hash,force_api[:email], force_api[:api_key])
    if res.class == Megam::Error
      profile = "http://support.megam.co/"
      err_msg= ActionController::Base.helpers.link_to 'Contact support', profile
      respond_to do |format|
        format.js {
          respond_with(err_msg, :layout => !request.xhr? )
        }
      end

    end
  end

end

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

  before_action :stick_keys, only: [:index, :show, :create]
  ##
  ## index page get all marketplace items from storage(we use riak) using megam_gateway
  ## and show the items in order of category
  ##
  def index
    logger.debug '> Marketplaces: index.'
    @mkp_grouped = Marketplaces.instance.list(params).mkp_grouped
  end

  ##
  ## to show the selected marketplace catalog item, appears if there are credits in billing.
  ##
  def show
    logger.debug '> Marketplaces: show.'
    Balances.new.show(params) do  |modb|
      unless modb.balance.credit.to_i > 0
        respond_to do |format|
          format.html { redirect_to billings_path }
          format.js { render js: "window.location.href='" + billings_path + "'" }
        end
      else
        @mkp = Marketplaces.instance.show(params).mkp
        versions = []
        versions = @mkp.plans.map { |c| c['version'] }.sort
        @ssh_keys = Sshkeys.new.list(params).ssh_keys
        @mkp = @mkp.to_hash
        @mkp['sversion'] = versions[0]
        @mkp['sversion'] = params['version'] if params.key?('version')
        @mkp['versions'] = versions

        assemblies_grouped = Assemblies.new.list(params).assemblies_grouped
        @apps = []
        assemblies_grouped["APP"].flatten.each do |one_assembly|
          one_assembly.components.flatten.map do |u|
            if u!=nil
              u.each do |com|
                @apps << {"name" => "#{one_assembly.name}.#{parse_key_value_pair(com.inputs, 'domain')}/#{com.name}", "aid" => one_assembly.id, "cid" => com.id }
              end
            end
          end
        end


        respond_to do |format|
          format.js do
            respond_with(@mkp, @ssh_keys, @apps, layout: !request.xhr?)
          end
        end
      end
    end
  end

  ## super cool - omni creator for all.
  # performs ssh creation or using existing and creating an assembly at the end.
  def create
    logger.debug '> Marketplaces: create.'
    mkp = JSON.parse(params[:mkp])
    Sshkeys.new.create_or_import(params)
    setup_scm(params)
    res = Assemblies.new.create(params) do
      # this is a successful call
    end
      Assembly.new.update(params) if params.has_key?(:bindedAPP)
      Components.new.update(params) if params.has_key?(:bindedAPP)
      @msg_hash = {:title => "#{mkp['cattype']} Creation",
      :msg => "#{mkp['cattype']} Created successfully with the name #{params['name']} . Content ==> #{mkp['predef']} #{mkp['sversion']}. You can browse #{params['name']}.#{params['domain']}. Thank you!",
      :redirect => "/", :alert => "success", :disposal_id => "app-1"}
  end

  ##
  ## after finish the github authentication the callback url comes this method
  ## this function parse the request and get the github credentials
  ## and store that credentials to session
  ##
  def store_github
    if current_user.nil?
      redirect_to controller: 'sessions', action: 'create'
    else
      @auth_token = request.env['omniauth.auth']['credentials']['token']
      session[:github] =  @auth_token
      session[:git_owner] = request.env['omniauth.auth']['extra']['raw_info']['login']
    end
  end

  ##
  ## this method collect all repositories for user using oauth token
  ##
  def publish_github
    auth_id = params['id']
    github = Github.new oauth_token: session[:github]
    git_array = github.repos.all.collect(&:clone_url)
    @repos = git_array
    respond_to do |format|
      format.js do
        respond_with(@repos, layout: !request.xhr?)
      end
    end
  end

  ##
  ## gogswindow html page method
  ##
  def start_gogs
  end

  ##
  ## get the repositories from session
  ## SCRP: What happens if gogs fails.
  def publish_gogs
    @repos = session[:gogs_repos]
    respond_to do |format|
      format.js do
        respond_with(@repos, layout: !request.xhr?)
      end
    end
  end

  ##
  ## this function get the gogs token using username and password
  ## then list the repositories using oauth tokens.
  ## SCRP: There is no error trap here. What happens if gogs fails ?
  def store_gogs
    session[:gogs_owner] = params[:gogs_username]
    tokens = ListGogsTokens.perform(params[:gogs_username], params[:gogs_password])
    session[:gogs_token] = JSON.parse(tokens)[0]['sha1']
    @gogs_repos = ListGogsRepo.perform(token)
    obj_repo = JSON.parse(@gogs_repos)
    @repos_arr = []
    obj_repo.each do |one_repo|
      @repos_arr << one_repo['clone_url']
    end
    session[:gogs_repos] =  @repos_arr
  end

  ##
  ## this controller launch the services
  ## it checks service is bind any of the applications, the service is bind to application then add the application name to inputs
  ##
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
    combo = combos.split('+')

    servicename = params[:servicename]
    if params[:bindedAPP] != '' && params[:bindedAPP] != 'select an APP'
      bindedAPP = params[:bindedAPP].split(':')
      appname = bindedAPP[0].split('/')[1]
      related_components = bindedAPP[0]
    else
      appname = nil
      related_components = nil
    end

    if type == 'postgresql'
      dbname = current_user.email
      dbpassword = ('0'..'z').to_a.sample(8).join
    end

    predef = GetPredefCloud.perform(params[:cloud], force_api[:email], force_api[:api_key])
    if predef.class == Megam::Error
      err_msg = "Please contact #{ActionController::Base.helpers.link_to 'support !.', 'http://support.megam.co/'}."
      respond_to do |format|
        format.js do
          respond_with(err_msg, layout: !request.xhr?)
        end
      end
    else
      # if predef[0].spec[:type_name] == "docker"
      #  ttype = "tosca.docker."
      # else
      ttype = 'tosca.web.'
      # end

      options = { instance: false, assembly_name: assembly_name, appname: appname, servicename: servicename, related_components: related_components, component_version: version, domain: domain, cloud: cloud, source: source, ttype: ttype, type: type, combo: combo, dbname: dbname, dbpassword: dbpassword  }
      app_hash = MakeAssemblies.perform(options, force_api[:email], force_api[:api_key])
      res = CreateAssemblies.perform(app_hash, force_api[:email], force_api[:api_key])
      if res.class == Megam::Error
        res_msg = nil
        err_msg = "Please contact #{ActionController::Base.helpers.link_to 'support !.', 'http://support.megam.co/'}."
        respond_to do |format|
          format.js do
            respond_with(res_msg, err_msg, layout: !request.xhr?)
          end
        end
      else
        if params[:bindedAPP] != '' && params[:bindedAPP] != 'select an APP'
          bindedAPP = params[:bindedAPP].split(':')
          get_assembly = GetAssemblyWithoutComponentCollection.perform(bindedAPP[1], force_api[:email], force_api[:api_key])
          if get_assembly.class == Megam::Error
            res_msg = nil
            err_msg = "Please contact #{ActionController::Base.helpers.link_to 'support !.', 'http://support.megam.co/'}."
            respond_to do |format|
              format.js do
                respond_with(res_msg, err_msg, layout: !request.xhr?)
              end
            end
          else
            get_component = GetComponent.perform(bindedAPP[2], force_api[:email], force_api[:api_key])
            if get_component.class == Megam::Error
              res_msg = nil
              err_msg = "Please contact #{ActionController::Base.helpers.link_to 'support !.', 'http://support.megam.co/'}."
              respond_to do |format|
                format.js do
                  respond_with(res_msg, err_msg, layout: !request.xhr?)
                end
              end
            else
              relatedcomponent = assembly_name + '.' + domain + '/' + servicename
              update_component_json = UpdateComponentJson.perform(get_component, relatedcomponent)
              update_component = UpdateComponent.perform(update_component_json, force_api[:email], force_api[:api_key])
              if update_component.class == Megam::Error
                res_msg = nil
                err_msg = "Please contact #{ActionController::Base.helpers.link_to 'support !.', 'http://support.megam.co/'}."
                respond_to do |format|
                  format.js do
                    respond_with(res_msg, err_msg, layout: !request.xhr?)
                  end
                end
              else
                update_json = UpdateAssemblyJson.perform(get_assembly, get_component)
                update_assembly = UpdateAssembly.perform(update_json, force_api[:email], force_api[:api_key])
                if update_assembly.class == Megam::Error
                  res_msg = nil
                  err_msg = "Please contact #{ActionController::Base.helpers.link_to 'support !.', 'http://support.megam.co/'}."
                  respond_to do |format|
                    format.js do
                      respond_with(res_msg, err_msg, layout: !request.xhr?)
                    end
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
    res_msg = 'success'
    err_msg = nil
  end

  private

  def setup_scm(params)
    case params[:scm_name]
    when Scm::GITHUB
      params[:scmtoken] =  session[:github]
      params[:scmowner] =  session[:git_owner]
    when Scm::GOGS
      params[:scmtoken] =  session[:gogs_token]
      params[:scmowner] =  session[:gogs_owner]
    else
      #we ignore it.
    end
  end
end

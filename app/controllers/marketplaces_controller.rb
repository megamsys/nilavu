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
    bill_check = false
    if Ind.billings
      Balances.new.show(params) do |modb|
          bill_check = true unless modb.balance.credit.to_i > 0       
      end    
    end
    if !bill_check
      @mkp = pressurize_version(Marketplaces.instance.show(params).mkp, params['version'])
      @ssh_keys = Sshkeys.new.list(params).ssh_keys
      @unbound_apps = unbound_apps(Assemblies.new.list(params.merge(flying_apps: 'true')).apps) if @mkp['cattype'] == Assemblies::SERVICE
      respond_to do |format|
        format.js do
          respond_with(@mkp, @ssh_keys, @unbound_apps, layout: !request.xhr?)
        end
      end
    else
      respond_to do |format|
         format.html { redirect_to billings_path }
         format.js { render js: "window.location.href='" + billings_path + "'" }
      end
    end
  end
  
  ## super cool - omni creator for all.
  # performs ssh creation or using existing and creating an assembly at the end.
  def create
    logger.debug '> Marketplaces: create.'
    mkp = JSON.parse(params[:mkp])
    # adding the default org of the user which is stored in the session
    params[:org_id] = session[:org_id]
    params[:ssh_keypair_name] = params["#{params[:sshoption]}" + '_name'] if params[:sshoption] == Sshkeys::USEOLD
    params[:ssh_keypair_name] = params["#{Sshkeys::NEW}_name"] unless params[:sshoption] == Sshkeys::USEOLD
    # the full keypair name is coined inside sshkeys.
    params[:ssh_keypair_name] = Sshkeys.new.create_or_import(params)[:name]
    setup_scm(params)
    # with email list all orgs, match with session[orgName], get orgid, update orgid
    res = Assemblies.new.create(params)

    binded_app?(params) do
      Assembly.new.update(params)
      Components.new.update(params)
    end if params.key?(:bind_type)
    @msg = { title: "#{mkp['cattype']}".downcase.camelize, message: "#{params['assemblyname']}.#{params['domain']} launched successfully. ", redirect: '/', disposal_id: 'app-1' }
  end

  ##
  ## after finish the github authentication the callback url comes to this method
  ## this function parses the request and gets the github credentials
  ## and stores that credentials to session.
  ##
  def store_github
    @auth_token = request.env['omniauth.auth']['credentials']['token']
    session[:github] =  @auth_token
    session[:git_owner] = request.env['omniauth.auth']['extra']['raw_info']['login']
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

  def start_gitlab
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
    session[:gogs_repos] = @repos_arr
  end

  def store_gitlab
    @gitlab_url = Ind.http_gitlab
    Gitlab.endpoint = @gitlab_url
    gitlab = Gitlab.session(params[:gitlab_username], params[:gitlab_password])
    session[:gitlab_key] = gitlab.private_token
    @lab_client = Gitlab.client(endpoint: @gitlab_url, private_token: gitlab.private_token)
    hash = []
    @lab_client.projects.each do |url|
      hash << url.http_url_to_repo
    end
    session[:gitlab_repos] = hash
  end

  def publish_gitlab
    @repos = session[:gitlab_repos]
    respond_to do |format|
      format.js do
        respond_with(@repos, layout: !request.xhr?)
      end
    end
  end

  private

  def binded_app?(params, &_block)
    yield if block_given? unless params[:bind_type].eql?('Unbound service')
  end

  def find_id(params)
    @endpoint = Gitlab.endpoint = Ind.http_gitlab
    client = Gitlab.client(endpoint: @endpoint, private_token: session[:gitlab_key])
    client.projects.each do |x|
      return x.id if x.http_url_to_repo == params
    end
 end

  def setup_scm(params)
    case params[:scm_name]
    when Scm::GITHUB
      params[:scmtoken] =  session[:github]
      params[:scmowner] =  session[:git_owner]
    when Scm::GOGS
      params[:scmtoken] =  session[:gogs_token]
      params[:scmowner] =  session[:gogs_owner]
    when Scm::GITLAB
      params[:scmtoken] = session[:gitlab_key]
      params[:scmowner] = find_id(params[:source])
      params[:scm_url]  = Ind.http_gitlab
    end
  end
end

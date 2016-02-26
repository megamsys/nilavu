##
## Copyright [2013-2016] [Megam Systems]
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

  before_action :add_authkeys_for_api, only: [:edit, :update]

  ##
  ## index page get all marketplace items from storage(we use riak) using megam_gateway
  ## and show the items in order of category
  ##
  def index
    @mkp_grouped = Api::Marketplaces.instance.list(params).mkp_grouped
  end

  ##
  ## to show the selected marketplace catalog item, appears if there are credits in billing.
  ##

  def show
    logger.debug '> Marketplaces: show.'
    @mkp = pressurize_version(Api::Marketplaces.instance.show(params).mkp, params['version'])
    @ssh_keys = Api::Sshkeys.new.list(params).ssh_keys
    @unbound_apps = unbound_apps(Api::Assemblies.new.list(params.merge(flying_apps: 'true')).apps) if @mkp['cattype'] == Api::Assemblies::SERVICE
    respond_to do |format|
      format.js do
        respond_with(@mkp, @ssh_keys, @unbound_apps, layout: !request.xhr?)
      end
    end
  end

  ## super cool - omni creator for all.
  # performs ssh creation or using existing and creating an assembly at the end.
  def create
    logger.debug '> Marketplaces: create.'
    params[:envs]= JSON.parse(params[:envs]) if params[:envs] != nil
    # adding the default org of the user which is stored in the session
    params[:ssh_keypair_name] = params["#{params[:sshoption]}" + '_name'] if params[:sshoption] == Api::Sshkeys::USEOLD
    params[:ssh_keypair_name] = params["#{Api::Sshkeys::NEW}_name"] unless params[:sshoption] == Api::Sshkeys::USEOLD
    # the full keypair name is coined inside sshkeys.
    params[:ssh_keypair_name] = Api::Sshkeys.new.create_or_import(params)[:name]
    setup_scm(params)
    res = Api::Assemblies.new.create(params)
    binded_app?(params) do
      Assembly.new.update(params)
      Components.new.update(params)
    end if params.key?(:bind_type)
    toast_success(cockpits_path, "Your #{params['cattype'].downcase} <b>#{params['assemblyname']}.#{params['domain']}</b> is firing up")
  end

  ##
  ## after finish the github authentication the callback url comes to this method
  ## this function parses the request and gets the github credentials
  ## and stores that credentials to session.
  ##
  def store_github
    @auth_token = request.env['omniauth.auth']['credentials']['token']
    session[:github] = @auth_token
    session[:github_owner] = request.env['omniauth.auth']['extra']['raw_info']['login']
  end

  def publish_github
    Nilavu::Repos::MegamGithub.new(session[:github]).tap do |gh|
      @repos = gh.repos
      respond_to do |format|
        format.js do
          respond_with(@repos, layout: !request.xhr?)
        end
      end
    end
  end


  def start_gitlab
  end

  def store_gitlab
    Nilavu::Repos::MegamGitlab.new(params[:gitlab_username], params[:gitlab_password]).tap do |gl|
      session[:gitlab_repos] = gl.repos
      session[:gitlab_key] = gl.token.private_token
    end
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
  def visit_paisa
    Balances.new.show(params) do |modb|
      respond_to do |format|
        format.html { redirect_to billings_path }
        format.js { render js: "window.location.href='" + billings_path + "'" }
      end  unless modb.balance.credit.to_i > 0
    end if Ind.has_key?("billings")
  end

  def binded_app?(params, &_block)
    yield if block_given? unless params[:bind_type].eql?('Unbound service')
  end

  def find_id(params)
    @endpoint = Gitlab.endpoint = Ind.gitlab
    client = Gitlab.client(endpoint: @endpoint, private_token: session[:gitlab_key])
    client.projects.each do |x|
      return x.id if x.http_url_to_repo == params
    end
  end

  def setup_scm(params)
    case params[:scm_name]
    when Nilavu::Constants::GITHUB
      params[:scmtoken] =  session[:github]
      params[:scmowner] =  session[:github_owner]
    when Nilavu::Constants::GITLAB
      params[:scmtoken] = session[:gitlab_key]
      params[:scmowner] = find_id(params[:source])
      params[:scm_url]  = Ind.gitlab
    end
  end
end

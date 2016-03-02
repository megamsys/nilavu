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

class LaunchersController < ApplicationController
  respond_to :js

  before_action :add_authkeys_for_api, only: [:launch]

  def launch
    @launch_item = HoneyPot.cached_marketplace_by_item(params)
    unless @launch_item
      return flash[:error] = 'Launch item that you clicked failed to load.'
    end

    respond_to do |format|
      format.js do
        respond_with(@launch_item, layout: !request.xhr?)
      end
    end
  end

  def perform_launch
=begin
    position = category_params.delete(:position)

    @category = Category.create(category_params.merge(user: current_user))

    if @category.save
      @category.move_to(position.to_i) if position

      Scheduler::Defer.later "Log staff action create category" do
        @staff_action_logger.log_category_creation(@category)
      end

      render_serialized(@category, CategorySerializer)
    else
      return render_json_error(@category) unless @category.save
    end
    #### -----
    @environment_vars = EnvironmentVars.build(params[:envs]) #params[:envs]= JSON.parse(params[:envs]) if params[:envs] != nil

    # adding the default org of the user which is stored in the session
    params[:ssh_keypair_name] = params["#{params[:sshoption]}" + '_name'] if params[:sshoption] == Api::Sshkeys::USEOLD
    params[:ssh_keypair_name] = params["#{Api::Sshkeys::NEW}_name"] unless params[:sshoption] == Api::Sshkeys::USEOLD
    # the full keypair name is coined inside sshkeys.
    params[:ssh_keypair_name] = Api::Sshkeys.new.create_or_import(params)[:name]
    setup_scm(params)

    res = Api::Assemblies.new.create(params)
    toast_success(cockpits_path, "Your #{params['cattype'].downcase} <b>#{params['assemblyname']}.#{params['domain']}</b> is firing up")
=end
  end

end

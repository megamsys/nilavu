class DeploysController < ApplicationController
  respond_to :js

  before_action :add_authkeys_for_api, only: [:show]

  def show
    @deployed = DeployedRunner.perform_run(params)  
    unless @deployed
      render_with_error('Deployed item that you clicked failed to load.')
    end

    respond_to do |format|
      format.js do
      respond_with(@deployed, layout: !request.xhr?)
     end
   end
  end
end

class TopicsController < ApplicationController
  respond_to :js

  before_action :add_authkeys_for_api, only: [:show]

  def show
    @deployed = DeployedRunner.perform_run(params)

    if @deployed
        render json: @deployed.to_h
    else
      render json: failed_json
    end
  end
end

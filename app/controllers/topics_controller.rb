class TopicsController < ApplicationController
  respond_to :html, :json


  before_action :add_authkeys_for_api, only: [:show]

  def show
    @deployed = DeployedRunner.perform_run(params)

    respond_to do |format|
      if @deployed
        format.html { render json: @deployed.to_h }
        format.json { render json: @deployed.to_h }
      else
        format.html { render json: failed_json }
        format.json { render json: failed_json }
      end
    end

  end
end

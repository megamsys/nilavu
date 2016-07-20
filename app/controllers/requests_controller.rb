class RequestsController < ApplicationController

  respond_to  :js


  before_action :add_authkeys_for_api, only: [:create, :destroy]

  def create
    Api::Requests.new.reqs(params.merge({:action => params[:req_action]}))
    render json: { success: true }
  end

  def destroy
    Api::Requests.new.reqs(params)
    render json: success_json
  end

end

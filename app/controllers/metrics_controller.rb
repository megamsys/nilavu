require 'rest-client'
class MetricsController < ApplicationController

  respond_to :html, :js
  def get
     if params[:type] == "machine"
      render json: machine(params[:ip])
     else
      render json: container(params[:ip])
     end
  end

private
def container(ip)
  response = RestClient.get("http://#{ip}:9999/api/v1.3/containers")
  return  response.body
end


def machine(ip)
  response = RestClient.get("http://#{ip}:9999/api/v1.3/machine")
  return response.body
end

end

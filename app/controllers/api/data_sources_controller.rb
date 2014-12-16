module Api
  class DataSourcesController  < ApplicationController
    respond_to :json
    def index
      plugin = Sources.plugin_clazz(params[:kind], params[:name])
      result = plugin.new.get(params,force_api[:email],force_api[:api_key])
      respond_with result.to_json
    end

  end
end
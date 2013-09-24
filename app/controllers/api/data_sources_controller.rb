module Api
  class DataSourcesController  < ApplicationController   
    respond_to :json
    def index         
      plugin = Sources.plugin_clazz(params[:kind], params[:name])
      puts plugin
      result = plugin.new.get(params)
      puts result.to_json     
    respond_with result.to_json
    end

  end
end
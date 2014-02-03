module Sources
  module NetworksDatapoints
    class Ganglia < Sources::NetworksDatapoints::Base
      #require 'xml'
      require 'open-uri'

      #
      # Configure the Ganglia URL and host in application.rb:
      #   config.ganglia_web_url  = ENV['GANGLIA_WEB_URL']
      #   config.ganglia_host     = ENV['GANGLIA_HOST']
      #
      # or use and environment variable:
      #   GANGLIA_WEB_URL=http://localhost:8080 rails s
      #
      # Target Selection:
      #   You need to know the cluster name, hostname and metric name. Usually its easy
      #   to obtain these from the graph url directly.
      #
      #   example: hostname@cluster(metric-name)
      #

      PORT = 8649

      def initialize
        @url_builder = GangliaUrlBuilder.new(Rails.configuration.ganglia_web_url)

      end

      def available?
        Rails.configuration.ganglia_web_url.present? && Rails.configuration.ganglia_host.present?
      end

      def get(options = {})
        #from    = (options[:from]).to_i
        #to      = (options[:to] || Time.now).to_i
        range = options[:range].to_s
        host    = getHost(options[:widgetid])       
        #graph_metric  = Rails.configuration.ganglia_graph_metric
        result_json = { } 
        #network_loop
        options[:target] = ["pkts_out", "pkts_in", "bytes_in", "bytes_out"]
        options[:target].each do |target|
        #graph_metric = (options[:target]).to_s
        graph_metric = target.to_s
        #targets = targets.reject(&:blank?)
        #ganglia_datapoints = request_datapoints(from, to, graph_metric, host)
           
        ganglia_datapoints = request_datapoints(range, graph_metric, host)      
        #ganglia_uptime = request_uptime(from, to, uptime_metric, host)
        #model_rpm = request_rpm(from, to, uptime_metric, host)
        result = []
        result << { "datapoints" => ganglia_datapoints, "metric" => graph_metric, "y_max" => 5}
        raise Sources::Datapoints::NotFoundError if result.empty?
        #result_json << {"#{graph_metric}" => result }
        #result_json = {"pkts_out" => result, "pkts_in" => result }
        #result_json << {"#{target}" => result }
        result_json["#{target}"] = result
        end
        #network_loop
        #TODO_TOM
        #Return result Array
        result_json
      end

      private

      def request_datapoints(range, target, host)
        result = []
        hash = @url_builder.datapoints_url(range, target, host)
        Rails.logger.debug("Requesting datapoints from #{hash[:url]} with params #{hash[:params]} ...")
        response = ::HttpService.request(hash[:url], :params => hash[:params])       
        if response == nil
          result << []
        else
          result << response.first["datapoints"]
        end
        result
      end

      def getHost(widget_id)
        widget  = Widget.find(widget_id.to_i)   
        dashboard_id = widget.dashboard_id        
        #dashboard = Dashboard.find(dashboard_id)    
        dashboard = CloudBook.find(dashboard_id)   
        dashboard.name                          
      end

    end
  end
end
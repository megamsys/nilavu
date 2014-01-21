module Sources
  module Datapoints
    class Ganglia < Sources::Datapoints::Base

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
        graph_metric = (options[:target]).to_s
        uptime_metric  = Rails.configuration.ganglia_request_metric
        #targets = targets.reject(&:blank?)
        #ganglia_datapoints = request_datapoints(from, to, graph_metric, host)   
        ganglia_datapoints = request_datapoints(range, graph_metric, host)      
        #ganglia_uptime = request_uptime(from, to, uptime_metric, host)
        ganglia_uptime = request_uptime(range, uptime_metric, host)
        #model_rpm = request_rpm(from, to, uptime_metric, host)
        model_rpm = request_rpm(range, uptime_metric, host)
        new_books = request_new_books(options)
        total_books = request_total_books(options)
        result = []
        result << { "datapoints" => ganglia_datapoints, "uptime_data" => ganglia_uptime, "rpm" => model_rpm, "new_books" => new_books, "total_books" => total_books, "total_queues" => Random.rand(10...100), "metric" => graph_metric}
        raise Sources::Datapoints::NotFoundError if result.empty?
        result
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

      def request_uptime(range, target, host)
        hash = @url_builder.data_url(range, target, host)
        Rails.logger.debug("Requesting Uptime from #{hash[:url]} with params #{hash[:params]} ...")
        response = ::HttpService.request(hash[:url], :params => hash[:params])
        Nokogiri::HTML(response).xpath("//table/tr/td/table/tr").collect do |row|
          if row.at("td[1]/text()").to_s == "Uptime"
            @timestamp   = row.at("td[2]/text()").to_s
          end
        end       
        if response == nil
          result = ""
        else
        #result << response.first["datapoints"]
        result = @timestamp
        end
        result
      end

      def request_rpm(range, target, host)
        Random.rand(10...100)
      end

      def request_new_books(options = {})
        widget  = Widget.find(options[:widgetid].to_i)   
        dashboard_id = widget.dashboard_id        
        #dashboard = Dashboard.find(dashboard_id)    
        dashboard = CloudBook.find(dashboard_id)   
        user_id = dashboard.users_id        
         c = CloudBook.where(:users_id => user_id).where(:created_at => Time.now - 7.days..Time.now).count  
         c
      end
      
      def request_total_books(options = {})
        widget  = Widget.find(options[:widgetid].to_i)
        dashboard_id = widget.dashboard_id
        #dashboard = Dashboard.find(dashboard_id)
        dashboard = CloudBook.find(dashboard_id)
        user_id = dashboard.users_id
        c = CloudBook.where(:users_id => user_id).count 
         c
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
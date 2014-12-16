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

      def get(options = {}, email, apikey)
        range = options[:range].to_s
       # host    = options[:appkey]     
       host = "improvident.megam.co" 
        result_json = {}
        
        uptime_metric  = Rails.configuration.ganglia_request_metric
        overview_hash = request_overview(range, uptime_metric, host)
        ganglia_uptime = overview_hash["uptime"]
        
        model_rpm = request_rpm(range, uptime_metric, host)
        result1 = {}
        result1 = { "uptime" => overview_hash["uptime"], "os" => overview_hash["os"], "cpus" => overview_hash["cpus"], "host" => host}
        
        
        target_hash={"cpu" => ["cpu_idle", "cpu_user", "cpu_system"], "disk" => ["disk_total", "disk_free"], "memory" => ["mem_free", "mem_cached"], "network" => ["bytes_out", "bytes_in"]}
        target_hash.each do |target_key, target_value|
          
        targets = target_value
        ganglia_datapoints = request_datapoints_dash(range, targets, host)        

        result = []
        targets.each_with_index do |target, index|
          result << { "target" => target, "datapoints" => ganglia_datapoints[index] }
        end
          result1["#{target_key}"] = result
         end #Each target_hash
        raise Sources::Datapoints::NotFoundError if result1.empty?
        puts "RESULT!!!!!!!11111111=======================================================================> "
        result1
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

      def request_datapoints_dash(range, targets, host)
        result = []
        targets.each do |target|
          hash = @url_builder.datapoints_url(range, target, host)
          Rails.logger.debug("Requesting datapoints from #{hash[:url]} with params #{hash[:params]} ...")
          response = ::HttpService.request(hash[:url], :params => hash[:params])
          if response == "null"
            result << []
          else
            result << response.first["datapoints"]
          end
        end
        result
      end
      
      
      def request_overview(range, target, host)
        hash = @url_builder.data_url(range, target, host)
        Rails.logger.debug("Requesting Uptime from #{hash[:url]} with params #{hash[:params]} ...")
        response = ::HttpService.request(hash[:url], :params => hash[:params])
        Nokogiri::HTML(response).xpath("//table/tr/td/table/tr").collect do |row|
          if row.at("td[1]/text()").to_s == "Uptime"
            @uptime   = row.at("td[2]/text()").to_s
          end
          if row.at("td[1]/text()").to_s == "Operating System"
            @os = row.at("td[2]/text()").to_s
          end
          if row.at("td[1]/text()").to_s == "CPU Count"
            @cpus = row.at("td[2]/text()").to_s
          end
          if row.at("td[1]/text()").to_s == "Memory Total"
            @memory = row.at("td[2]/text()").to_s
          end
        end       
        if response == nil
          result = ""
        else
        #result << response.first["datapoints"]
        #result = @timestamp
        #result = {"uptime" => "#{@uptime}", "os" => "#{@os}", "cpus" => "#{@cpus}", "memory" => "#{@memory}"}
        result = {"uptime" => "#{@uptime}", "os" => "#{@os}", "cpus" => "#{@cpus}"}
        end
        result
      end
    

      def request_rpm(range, target, host)
        Random.rand(10...100)
      end    

    end
  end
end

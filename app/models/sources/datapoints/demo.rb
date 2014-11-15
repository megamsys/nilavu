module Sources
  module Datapoints
    class Demo < Sources::Datapoints::Base
=begin      
     def get(options = {})
        from    = (options[:from]).to_i
        to      = (options[:to] || Time.now).to_i       

        graph_datas = []       
          graph_datas << {:datapoints => ::DemoHelper.generate_datapoints(from, to), :uptime_data => ::DemoHelper.get_rand_data(from, to), :rpm => ::DemoHelper.get_rand_data(from, to), :new_books => Random.rand(10...100), :total_books => Random.rand(10...100), :total_queues => Random.rand(10...100), :metric => "demo_values" }       
        graph_datas
      end
=end      
      def get(options = {})
        puts "RESULT!!!!!!!11111111=======================================================================> "
        from    = (options[:from]).to_i
        to      = (options[:to] || Time.now).to_i                   
        result_json = {}        
     #  host    = getHost(options[:widgetid])
        host = "app1.megam.co"
       uptime = Random.rand(10...100) 
       os =  Random.rand(10...100)
       cpus = Random.rand(10...100)  
       
        
        model_rpm = Random.rand(10...100)
        new_books = Random.rand(10...100)
        total_books = Random.rand(10...100)
        result1 = {}
        result1 = { "uptime" => uptime, "os" => os, "cpus" => cpus, "host" => host}
        
        
        target_hash={"cpu" => ["cpu_idle", "cpu_user", "cpu_system"], "disk" => ["disk_total", "disk_free"], "memory" => ["mem_free", "mem_cached"], "network" => ["bytes_out", "bytes_in"]}
        target_hash.each do |target_key, target_value|
          
        targets = target_value
        ganglia_datapoints = request_datapoints_dash(from, to, targets)     

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
     
     def request_datapoints_dash(from, to, targets)
        result = []
        targets.each do |target|                
          response = ::DemoHelper.generate_datapoints(from, to)           
          if response == "null"
            result << []
          else
            result << response
          end
        end
        result
      end
     
      def getHost(widget_id)
        widget  = Widget.find(widget_id.to_i)   
        dashboard_id = widget.dashboard_id        
        #dashboard = Dashboard.find(dashboard_id)    
        dashboard = App.find(dashboard_id)   
        dashboard.name                           
      end
     
    end
  end
end
  
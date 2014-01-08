module Sources
  module Datapoints
    class Demo < Sources::Datapoints::Base
     def get(options = {})
        from    = (options[:from]).to_i
        to      = (options[:to] || Time.now).to_i       

        graph_datas = []       
          graph_datas << {:datapoints => ::DemoHelper.generate_datapoints(from, to), :uptime_data => ::DemoHelper.get_rand_data(from, to), :rpm => ::DemoHelper.get_rand_data(from, to) }       
        graph_datas
      end
     
    end
  end
end
  
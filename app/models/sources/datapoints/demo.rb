module Sources
  module Datapoints
    class Demo < Sources::Datapoints::Base
     def get(options = {})
        from    = (options[:from]).to_i
        to      = (options[:to] || Time.now).to_i       

        graph_datas = []       
          graph_datas << {:datapoints => ::DemoHelper.generate_datapoints(from, to), :uptime_data => ::DemoHelper.get_rand_data(from, to), :rpm => ::DemoHelper.get_rand_data(from, to), :new_books => Random.rand(10...100), :total_books => Random.rand(10...100), :total_queues => Random.rand(10...100), :metric => "demo_values" }       
        graph_datas
      end
     
    end
  end
end
  
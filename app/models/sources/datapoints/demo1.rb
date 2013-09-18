module Sources
  module Datapoints
    class Demo1 < Sources::Datapoints::Base
       def get(options = {})
        from    = (options[:from]).to_i
        to      = (options[:to] || Time.now).to_i       

        datapoints = []       
          datapoints << {:datapoints => ::DemoHelper.generate_datapoints(from, to), :uptime_data => ::DemoHelper.get_rand_data(from, to), :rpm => ::DemoHelper.get_rand_data(from, to) }       
        datapoints
      end
      

    end
  end
end
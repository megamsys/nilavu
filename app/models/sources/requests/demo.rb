module Sources
  module Requests
    class Demo
      #def get(options = {})
       # { :value => Random.rand(10...100) }
      #end

      def get(options = {})
        from    = (options[:from]).to_i
        to      = (options[:to] || Time.now).to_i       

        datapoints = []       
          datapoints << {:datapoints => ::DemoHelper.generate_datapoints(from, to) }       
        datapoints
      end
  
    end

  end
end

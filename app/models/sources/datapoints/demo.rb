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
      
=begin      
      def get()
        data = []
        totalPoints = 300
        datapoints = []

        if (data.length > 0)
        data = data.slice(1)
        end

        while data.length < totalPoints do
          prev = data.length > 0 ? data[data.length - 1] : 50          
          y = prev + Random.rand() * 10 - 5           
           
          if (y < 0)
          y = 0
          else if (y > 100)
            y = 100
            end
          data.push(y)
          end
          
          res = []
          for i in 0..data.length
            res.push([i, data[i]])
          end
          datapoints = res
          datapoints = [ [ [0, 0], [1, 2], [10, 4], [11, 6], [4, 8] ] ];
=end

          data1 =  [ [Random.rand(10...20), Random.rand(10...42)], [Random.rand(10...30), Random.rand(10...42)], [Random.rand(10...42), Random.rand(10...12)], [Random.rand(10...42), Random.rand(10...62)], [Random.rand(10...22), Random.rand(10...42)] ]
          datapoints = data1
          datapoints
        end

      end
    end
  #end
#end
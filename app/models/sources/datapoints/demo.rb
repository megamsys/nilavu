module Sources
  module Datapoints
    class Demo
      def get()
        puts "==========="
        puts "Demo1"
        data = []
        totalPoints = 300;
        datapoints = []
=begin        
        if (data.length > 0)
        data = data.slice(1)
        end

        while data.length < totalPoints do
          prev = data.length > 0 ? data[data.length - 1] : 50,
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
          #datapoints = [ [ [0, 0], [1, 2], [10, 4], [11, 6], [4, 8] ] ];
=end
         data1 =  [ [Random.rand(10...42), Random.rand(10...42)], [Random.rand(10...42), Random.rand(10...42)], [Random.rand(10...42), Random.rand(10...42)], [Random.rand(10...42), Random.rand(10...42)], [Random.rand(10...42), Random.rand(10...42)] ]
         datapoints = data1
          datapoints
        end
         
      end
    end
  end
#end
module Sources
  module Datapoints
    class Demo
      def get()
        puts "==========="
        puts "Demo2"
        datapoints = []
               
        data1 = [ [ [Random.rand(10...42), Random.rand(10...42)], [Random.rand(10...42), Random.rand(10...42)], [Random.rand(10...42), Random.rand(10...42)], [Random.rand(10...42), Random.rand(10...42)], [Random.rand(10...42), Random.rand(10...42)] ] ]     
      
        datapoints = data1
        
        #datapoints = [ [ [0, 0], [1, 2], [10, 4], [11, 6], [4, 8] ] ];
        datapoints
      end

    end
  end
end
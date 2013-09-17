module Sources
  module Queuetraffic
    class Demo
      def get(options = {})
        { :value => Random.rand(10...100) }
      end

    end

  end
end

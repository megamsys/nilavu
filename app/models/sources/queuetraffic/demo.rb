module Sources
  module Queuetraffic
    class Demo < Sources::Queuetraffic::Base
      def get(options = {})
        { :value => Random.rand(10...100) }
      end

    end

  end
end

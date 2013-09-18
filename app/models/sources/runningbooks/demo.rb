module Sources
  module Runningbooks
    class Demo < Sources::Runningbooks::Base
      def get(options = {})
        { :value => Random.rand(10...100) }
      end

    end

  end
end

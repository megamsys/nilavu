module Sources
  module Cumulativeuptime
    class Demo < Sources::Cumulativeuptime::Base
      def get(options = {})
        { :value => Random.rand(10...100) }
      end

    end

  end
end

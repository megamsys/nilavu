module Sources
  module Uptime
    class Demo < Sources::Uptime::Base
      def get(options = {})
        { :value => Random.rand(10...100) }
      end

    end

  end
end

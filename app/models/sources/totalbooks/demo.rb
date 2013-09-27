module Sources
  module Totalbooks
    class Demo < Sources::Totalbooks::Base
      def get(options = {})
        { :value => Random.rand(10...100) }
      end

    end

  end
end

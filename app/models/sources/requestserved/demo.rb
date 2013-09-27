module Sources
  module Requestserved
    class Demo < Sources::Requestserved::Base
      def get(options = {})
        { :value => Random.rand(10...100) }
      end

    end

  end
end

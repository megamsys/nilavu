module Sources
  module Queue
    class Demo < Sources::Queue::Base
      def get(options = {})
        { :value => Random.rand(10...100) }
      end

    end

  end
end

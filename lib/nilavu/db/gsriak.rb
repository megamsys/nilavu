module Nilavu
  module DB
    class GSRiak
      attr_reader :client # riak client
      attr_reader :bname  # bucket name

      class RiakError < StandardError; end

      def initialize(bname)
        @bname = bname
        require 'ind'
        @client = Riak::Client.new(nodes: [{ host: "#{Ind.riak}" }])
      end

      def upload(key, data, content_type)
        object = @client.bucket(@bname).get_or_new(key)
        object.raw_data = data
        object.content_type = content_type
        object.store
      end

      def download(key)
        object = @client.bucket(@bname).get_or_new(key)
        File.open(File.basename(key), 'wb') do |file|
          file.write(object.raw_data)
	         #file.chmod(0600)
         end
	        #File.chmod(600, File.basename(key))
      end

      def fetch(key)
        object = @client.bucket(@bname).get_or_new(key)
        object.content_type = 'application/json'
        object.fetch
      end
    end
  end
end

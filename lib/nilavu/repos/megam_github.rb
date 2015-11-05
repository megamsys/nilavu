module Nilavu
  module Repos
    class MegamGithub < Repository
      attr_reader :client, :token
      def initialize(tok)
        #token(tok)
        @client = Github.new oauth_token: tok
      end

      ##
      ## this method collect all repositories for user using oauth token
      ##
      def repos
        @client.repos.all.collect(&:clone_url)
      end

      def token(arg=nil)
        if(arg!=nil)
          token = arg
        else
          token
        end
      end
    end
  end
end

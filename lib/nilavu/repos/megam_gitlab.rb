module Nilavu
  module Repos
    class MegamGitlub < Repository
      attr_reader :username, :password

      def initialize(username, password)
        @username = username
        @password = password
      end

      def token
        Gitlab.session(username, password).private_token
      end

      def repos
        glr = []
        Gitlab.client(endpoint: endpoint, private_token: token).projects.each do |url|
          glr << url.http_url_to_repo
        end
        glr
      end

      def endpoint
        Ind.http_gitlab
      end
    end
  end
end

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
        SiteSetting.gitlab_host
      end

      #      def find_id(params)
      #          @endpoint = Gitlab.endpoint = Ind.gitlab
      #          client = Gitlab.client(endpoint: @endpoint, private_token: session[:gitlab_key])
      #          client.projects.each do |x|
      #            return x.id if x.http_url_to_repo == params
      #          end
      #        end

      #        def setup_scm(params)
      #          case params[:scm_name]
      #          when Nilavu::Constants::GITHUB
      #            params[:scmtoken] =  session[:github]
      #            params[:scmowner] =  session[:github_owner]
      #          when Nilavu::Constants::GITLAB
      #            params[:scmtoken] = session[:gitlab_key]
      #            params[:scmowner] = find_id(params[:source])
      #            params[:scm_url]  = Ind.gitlab
      #          end
      #        end
      end
  end
end

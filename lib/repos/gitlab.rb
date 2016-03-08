module Gitlabber

  def self.repos
    glr = []
    Gitlab.client(endpoint: endpoint, private_token: token).projects.each do |url|
      glr << url.http_url_to_repo
    end
    glr
  end

  def self.endpoint
    SiteSetting.gitlab_host
  end

  private

  def self.token(username, password)
    Gitlab.session(username, password).private_token
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

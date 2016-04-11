class GithubController < ApplicationController

  skip_before_filter :redirect_to_login_if_required

  def list
    ensure_oauth_token(params)

    @repos = Githubber.repos(session[:authentication][:token])
    render_json_dump(@repos)
  end

  def ensure_oauth_token(params)
    session[:authentication] && session[:authentication][:token]
  end
end

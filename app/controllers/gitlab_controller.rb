class GitlabController < ApplicationController

skip_before_filter :redirect_to_login_if_required

  def show
  end

def list
  @repos = Gitlabber.repos(params[:gitlab_username],params[:gitlab_password])
  render_json_dump(@repos)
end
end

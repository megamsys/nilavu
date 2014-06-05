class VisualisationsController < ApplicationController
  before_filter :require_login

  def show
    #@containers = !cookies[:donabe_ip].nil?
    respond_to do |format|
      format.html
    end
  end

  private

  def require_login
    session[:current_user_id] ||= cookies[:current_user_id]
    session[:current_token] ||= cookies[:current_token]

    unless logged_in?
      flash[:error] = "Please login to access designer!"
      redirect_to login_url
    end
  end

end

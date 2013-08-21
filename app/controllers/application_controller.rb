class ApplicationController < ActionController::Base

  protect_from_forgery
  include SessionsHelper

  #If the requests donot come from local then the exception page will be shown.
  #a catcher exists using rails globber for routes in config/application.rb to trap 404.
  unless Rails.application.config.consider_all_requests_local
    rescue_from Exception, with: :render_500
    rescue_from ActionController::RoutingError, with: :render_404
    rescue_from ActionController::UnknownController, with: :render_404
    rescue_from AbstractController::ActionNotFound, with: :render_404
    rescue_from ActiveRecord::RecordNotFound, with: :render_404
  end

 

  # renders 404 in an exception template.
  # A generic template exists in error which shows the error in a
  # usage way.
  def render_404(exception = nil)
    @not_found_path = exception.message if exception
    respond_to do |format|
      format.html { render template: 'errors/not_found', layout: 'application', status: 404 }
      format.all { render nothing: true, status: 404 }
    end
  end
  
 # renders 505 in an exception template.
  # A generic template exists in error which shows the error in a
  # usage way.
  def render_500(exception = nil)
    if exception
      Rails.logger.fatal "\n#{exception.class.to_s} (#{exception.message})"
      Rails.logger.fatal exception.backtrace.join("\n")
    end
    respond_to do |format|
      format.html { render template: 'errors/internal_server_error', layout: 'application', status: 500 }
      format.all { render nothing: true, status: 500}
    end
  end
end

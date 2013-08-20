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

  # renders 505 in an exception template.
  # A generic template exists in error which shows the error in a
  # usage way.
=begin
  def render_500(exception)
    render_exception(500, exception.message, exception)
  end
=end
  # renders 404 in an exception template.
  # A generic template exists in error which shows the error in a
  # usage way.
  def render_404(exception = nil)
    render_exception(404, 'Page not found', exception)
  end

=begin
  def render_500(exception = nil)
    render_exception(500, 'Internal server error', exception)
  end
=end

  def render_500(exception)
    @exception = exception
    render :template => "shared/500.html", :status => 500
  end

  # renders an exception in  template.
  # A generic template exists in error which shows the error in a  usage way.
  # The error is logged in the rails log file
  def render_exception(status = 500, message = 'Server error', exception)
    @status = status
    @message = message

    if exception
      Rails.logger.fatal "\n#{exception.class.to_s} (#{exception.message})"
      Rails.logger.fatal exception.backtrace.join("\n")
    else
      Rails.logger.fatal "No route matches [#{env['REQUEST_METHOD']}] #{env['PATH_INFO'].inspect}"
    end

    render template: "errors/error", formats: [:html], layout: 'application', status: @status
  end

end

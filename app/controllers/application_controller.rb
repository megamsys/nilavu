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
#      twit_msg  =  "http://www.megam.co: error, support issue created.".slice! 0..140
#      client = Twitter::REST::Client.new do |config|
#        config.consumer_key        = ENV['TWITTER_CLIENT_ID']
#        config.consumer_secret     = ENV['TWITTER_SECRET_KEY']
#        config.access_token        =ENV['TWITTER_ACCESS_TOKEN']
#        config.access_token_secret =ENV['TWITTER_ACCESS_TOKEN_SECRET']
#      end
#      begin
#        client.update(twit_msg)
#      rescue Twitter::Error
#      ## just ignore twitter errors.
#      end

      short_msg = "(#{exception.message})"
      filtered_trace = exception.backtrace.grep(/#{Regexp.escape("nilavu")}/)
      if !filtered_trace.empty?
        full_stacktrace =  filtered_trace.join("\n")
        Rails.logger.fatal "\n#{short_msg}"
        Rails.logger.fatal "#{full_stacktrace}"
        UserMailer.error_email({:email => current_user.email, :message =>"#{short_msg}", :stacktrace => "#{full_stacktrace}" }).deliver
      end
    end
    respond_to do |format|
      format.html { render template: 'errors/internal_server_error', layout: 'application', status: 500 }
      format.js { render template: 'errors/internal_server_error', layout: 'application', status: 500 }
      format.all { render nothing: true, status: 500}
    end
  end
end

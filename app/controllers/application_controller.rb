##
## Copyright [2013-2015] [Megam Systems]
##
## Licensed under the Apache License, Version 2.0 (the "License");
## you may not use this file except in compliance with the License.
## You may obtain a copy of the License at
##
## http://www.apache.org/licenses/LICENSE-2.0
##
## Unless required by applicable law or agreed to in writing, software
## distributed under the License is distributed on an "AS IS" BASIS,
## WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
## See the License for the specific language governing permissions and
## limitations under the License.
##
class ApplicationController < ActionController::Base
  include SessionsHelper

  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }

  before_action :require_signin
  around_action :catch_exceptions

  #a catcher exists using rails globber for routes in config/application.rb to trap 404.
  unless Rails.application.config.consider_all_requests_local
    rescue_from Exception, with: :render_500
    rescue_from ActionController::RoutingError, with: :render_404
    rescue_from ActionController::UnknownController, with: :render_404
    rescue_from AbstractController::ActionNotFound, with: :render_404
    rescue_from ActiveRecord::RecordNotFound, with: :render_404
    rescue_from Timeout::Error, :with => :render_500
    rescue_from Errno::ECONNREFUSED, Errno::EHOSTUNREACH, :with => :render_500
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

  private

  #if the request is from the root url (eg: console.megam.io) then no message is shown
  #if the request is form a non root url like users/1/edit, then we show  message.
  def require_signin
    unless signed_in?
      if (request.fullpath.to_s == '/' || request.original_url.to_s == '/')
        redirect_to signin_path
      else
        redirect_to signin_path, :flash => { :error => "You must first sign in or sign up."}
      end
    end
  end

  def stick_keys(tmp={}, permitted_tmp={})
    logger.debug "> STICK #{params}"
    params[:email] = session[:email]
    params[:api_key] = session[:api_key]
    logger.debug "> STICKD #{params}"
    params
  end

  def catch_exceptions
    yield
  rescue Accounts::MegamAPIError  => mai
    logger.debug "*-----------------------*"
    logger.debug "|    (˘_˘) exception    :"
    logger.debug "*-----------------------*"
    logger.debug "#{mai.message}"
    logger.debug ">>>> caused by Nak man (‾ʖ̫‾) : "
   # mai.backtrace.each { |line| logger.error line }
    logger.debug "*-----------------------*"
    #notify Megam ? - hipchat
    #send an email to support@megam.io which creates a support ticket.
    #redirect to the users last visited page.
    redirect_to signin_path, :flash => { :error => "oops! there is some issue. ticket created - support.megam.io" } and return
  end
end

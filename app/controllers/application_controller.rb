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

  protect_from_forgery with: :null_session, if: proc { |c| c.request.format == 'application/json' }

  before_action :require_signin
  around_action :catch_exceptions
  before_filter :set_user_language

  #for internationalization

  def set_user_language
    I18n.locale= 'en'

  end
  
  # a catcher exists using rails globber for routes in config/application.rb to trap 404.
  rescue_from Exception, with: :render_500
  unless Rails.application.config.consider_all_requests_local
    rescue_from ActionController::RoutingError, with: :render_404
    rescue_from ActionController::UnknownController, with: :render_404
    rescue_from AbstractController::ActionNotFound, with: :render_404
    rescue_from ActiveRecord::RecordNotFound, with: :render_404
    rescue_from Timeout::Error, with: :render_500
    rescue_from Errno::ECONNREFUSED, Errno::EHOSTUNREACH, with: :render_500
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
    puts_stacktrace(exception) if exception
    respond_to do |format|
      format.html { render template: 'errors/internal_server_error', layout: 'application', status: 500 }
      format.js { render template: 'errors/internal_server_error', layout: 'application', status: 500 }
      format.all { render nothing: true, status: 500 }
    end
  end

  private

  # if the request is from the root url (eg: console.megam.io) then no message is shown
  # if the request is form a non root url like users/1/edit, then we show  message.
  def require_signin
    if signed_in?
    else
       if request.fullpath.to_s == '/' || request.original_url.to_s == '/'
         redirect_to signin_path
       else
         if request.fullpath.to_s.match('auth')
           auth = request.env['omniauth.auth']['extra']['raw_info']
           session[:auth] = { email: auth[:email], first_name: auth[:first_name], last_name: auth[:last_name] }
           redirect_to social_create_path
         else
           redirect_to signin_path, flash: { error: 'You must first sign in or sign up.' }
         end
       end
     end
  end

  def stick_keys(_tmp = {}, _permitted_tmp = {})
    logger.debug "> STICK #{params}"
    params[:email] = session[:email]
    params[:api_key] = session[:api_key]
    params[:host]    = Ind.http_api
    logger.debug "> STICKD #{params}"
    params
  end
  
  def stick_host(_tmp = {}, _permitted_tmp = {})
    logger.debug "> STICK #{params}"   
    params[:host]    = Ind.http_api
    logger.debug "> STICKD #{params}"
    params
  end
  
  def stick_storage_keys(_tmp = {}, _permitted_tmp = {})
    logger.debug "> STICK #{params}"
    params[:accesskey] = session[:storage_access_key]
    params[:secretkey] = session[:storage_secret_key]
    logger.debug "> STICKD #{params}"
    params
  end

  def catch_exceptions
    yield
  rescue Accounts::MegamAPIError => mai
    ascii_bomb
    puts_stacktrace(mai)
    # notify  hipchat, send an email to support@megam.io which creates a support ticket.
    # redirect to the users last visited page.
    redirect_to(signin_path, flash: { error: 'oops! there is some issue. ticket created - support.megam.io' }) && return
  rescue ApplicationMailer::MegamSnailError => mse
    ascii_snail
    puts_stacktrace(mse)
  end

  def ascii_bomb
    logger.debug ''"\033[31m
       ,--.!,
    __/   -*-
  ,####.  '|`
  ######
  `####'                !\033[0m\033[1mWe flunked!\033[22m
"''
  end

  def ascii_snail
    logger.debug ''"\033[31m
   .----.   @   @
  / .-.-.`.  \\v/
  | | '\\ \\ \\_/ )
,-\\ `-.' /.'  /
'---`----'----'        !\033[0m\033[1mSnail race is on! to deliver your mail!\033[22m
"''
  end 

  def puts_stacktrace(exception)
    logger.debug "\033[36m#{exception.message}\033[0m"
    filtered_trace = exception.backtrace.grep(/#{Regexp.escape("nilavu")}/)
    unless filtered_trace.empty?
      full_stacktrace = filtered_trace.join("\n")
      logger.debug "\033[1m\033[32m#{full_stacktrace}\033[0m\033[22m"
    end
    logger.debug "\033[1m\033[35m..(*_*)...\033[0m\033[22m"
  end
end

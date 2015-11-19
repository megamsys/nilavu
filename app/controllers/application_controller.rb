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
require 'nilavu'
require 'nilavu/error'

class ApplicationController < ActionController::Base
  include SessionsHelper

  protect_from_forgery with: :null_session, if: proc { |c| c.request.format == 'application/json' }

  around_action :catch_exceptions
  before_filter :set_locale

  # for internationalization
  def set_locale
    I18n.locale = Ind.locale
  end


  #############################################################################
  # Exception Handling (We will have to move this to a separate handler)
  #############################################################################

  # a catcher exists using rails globber for routes in config/application.rb to trap 404.
  rescue_from Exception, with: :render_500
  unless Rails.application.config.consider_all_requests_local
    rescue_from ActionController::RoutingError, with: :render_404
    rescue_from ActionController::UnknownController, with: :render_404
    rescue_from AbstractController::ActionNotFound, with: :render_404
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
    log_exception(exception)
    respond_to do |format|
      format.html { render template: 'errors/internal_server_error', layout: 'application', status: 500 }
      format.js { render template: 'errors/internal_server_error', layout: 'application', status: 500 }
      format.all { render nothing: true, status: 500 }
    end
  end

  private
  ## we will move this to our own lib
  def catch_exceptions
    yield
  rescue Nilavu::MegamGWError => mew
    log_exception(mew)
    toast_error(redirect_where, mew.message) && return
  end

  def log_exception(exception)
    trace = filter_exception(exception) if exception
    unless trace.empty?
      log_trace(trace)
      ascii_bomb
    end
  end

  #just show our stuff .
  def filter_exception(exception, by='nilavu')
    logger.debug "\033[1m\033[32m#{exception.message}\033[0m\033[22m"
    exception.backtrace.grep(/#{Regexp.escape("#{by}")}/)
  end

  def log_trace(trace)
    trace = (trace.map { |ft| ft.split('/').last }).join("\n")
    logger.debug "\033[1m\033[36m#{trace}\033[0m\033[22m"
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

  #############################################################################
  # Toastr - growl messages
  #############################################################################
  def redirect_where
    if signed_in?
      cockpits_path
    end
    signin_path
  end

  
  def toast_info(path, msg)
      redirect_to(path, :flash => { :info => msg})
  end

  def toast_success(path, msg)
    redirect_to(path, :flash => { :notice => msg})
  end

  def toast_error(path, msg)
    redirect_to(path||=redirect_where,:flash => {:alert => msg })
  end

  def toast_warn(path, msg)
    redirect_to(path, :flash => {:warning => msg})
  end
end

##
## Copyright [2013-2016] [Megam Systems]
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

require 'current_user'
require_dependency 'nilavu'
require_dependency 'global_path'
require_dependency 'global_exceptions'


class ApplicationController < ActionController::Base
  include CurrentUser
  include GlobalPath
  include GlobalExceptions

  protect_from_forgery

  before_filter :set_locale
  before_filter :disable_customization
  before_filter :redirect_to_login_if_required
  before_filter :set_current_user_with_org
  around_action :catch_exceptions



  # Some exceptions
  class RenderEmpty < StandardError; end

  # Render nothing
  rescue_from RenderEmpty do
    render 'default/empty'
  end

  rescue_from Nilavu::NotLoggedIn do |e|
    raise e if Rails.env.test?
    if (request.format && request.format.json?) || request.xhr? || !request.get?
      rescue_nilavu_actions(:not_logged_in, 403, true)
    else
      rescue_nilavu_actions(:not_found, 404)
    end
  end

  rescue_from Nilavu::NotFound do
    rescue_nilavu_actions(:not_found, 404)
  end

  rescue_from Nilavu::InvalidAccess do
    rescue_nilavu_actions(:invalid_access, 403, true)
  end

  def rescue_nilavu_actions(type, status_code)
    if (request.format && request.format.json?) || (request.xhr?)
      render_json_error I18n.t(type), type: type, status: status_code
    else
      render text: build_not_found_page(status_code)
    end
  end

  def set_locale
    I18n.locale = SiteSetting.default_locale
    I18n.ensure_all_loaded!
  end


  def redirect_to_login_if_required
    return if current_user
    session[:destination_url] = destination_url
    redirect_to path('/signin')
  end


  def set_current_user_with_org
    if current_user && current_user.org_id.blank?
      org_id = Api::Organizations.new.list(AuthBag.vertice(current_user)).first
      unless org_id.blank?
        current_user.org_id = org_id
      end
    end
  end


  def disable_customization
    session[:disable_customization] = params[:customization] == "0" if params.has_key?(:customization)
  end

  def add_authkeys_for_api
    logger.debug "> STICKM"
    params.merge!(AuthBag.vertice(current_user))
  end

  def current_homepage
    current_user ? SiteSetting.homepage : SiteSetting.anonymous_homepag
  end

  private
  #def custom_html
  #  data = {
  #    top: SiteCustomization.custom_top(session[:preview_style]),
  #    footer: SiteCustomization.custom_footer(session[:preview_style])
  #  }
  #
  # if NilavuPluginRegistry.custom_html
  #    data.merge! NilavuPluginRegistry.custom_html
  #  end

  #end

  def check_xhr
    # bypass xhr check on PUT / POST / DELETE provided api key is there, otherwise calling api is annoying
    return if !request.get? && api_key_valid?
    raise RenderEmpty.new unless ((request.format && request.format.json?) || request.xhr?)
  end

  def ensure_logged_in
    raise Nilavu::NotLoggedIn.new unless current_user.present?
  end

  def destination_url
    #    request.original_url unless request.original_url =~ /uploads/
    request.original_url
  end

  def build_not_found_page(status=404)
    render_to_string status: status, formats: [:html], template: '/errors/not_found'
  end

  protected

  # returns an array of integers given a param key
  # returns nil if key is not found
  def param_to_integer_list(key, delimiter = ',')
    if params[key]
      params[key].split(delimiter).map(&:to_i)
    end
  end

  def redirect_wtih_info(path, key, msg={})
    redirect_to(path,:flash => {:info => I18n.t(key,errors: "#{msg.map{|k,v| "#{k}: #{v}"}.join("\n")}")})
  end

  def redirect_with_success(path, key,  msg={})
    redirect_to(path,:flash => {:notice => I18n.t(key,errors: "#{msg.map{|k,v| "#{k}: #{v}"}.join("\n")}")})
  end

  def redirect_with_failure(path, key, msg={})
    redirect_to(path,:flash => {:alert => I18n.t(key,errors: "#{msg.map{|k,v| "#{k}: #{v}"}.join("\n")}")})
  end

  def redirect_with_warning(path, key, msg={})
    redirect_to(path,:flash => {:warning => I18n.t(key,errors: "#{msg.map{|k,v| "#{k}: #{v}"}.join("\n")}")})
  end
end

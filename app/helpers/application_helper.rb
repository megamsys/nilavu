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
require_dependency 'global_path'

module ApplicationHelper
  include CurrentUser
  include GlobalPath

  def ga_universal_json
    cookie_domain = SiteSetting.ga_universal_domain_name.gsub(/^http(s)?:\/\//, '')
    result = {cookieDomain: cookie_domain}
    if current_user.present?
      result[:userId] = current_user.id
    end
    result.to_json.html_safe
  end

  def escape_unicode(javascript)
    if javascript
      javascript = javascript.scrub
      javascript.gsub!(/\342\200\250/u, '&#x2028;')
      javascript.gsub!(/(<\/)/u, '\u003C/')
      javascript.html_safe
    else
      ''
    end
  end

  def guardian
    @guardian ||= Guardian.new(current_user)
  end

  def mini_profiler_enabled?
    defined?(Rack::MiniProfiler) && admin?
  end

  def admin?
    current_user.try(:admin?)
  end

  def staff?
    current_user.try(:staff?)
  end


  def application_logo_url
    @application_logo_url ||=  SiteSetting.logo_url
  end


  def script(*args)
    javascript_include_tag(*args)
  end

  def nilavu_csrf_tags
    if current_user
      csrf_meta_tags
    end
  end

  def mobile_view?
    false
  end

  def customization_disabled?
    session[:disable_customization] || SiteSetting.disable_customization
  end

  def render_customized_header_or_not
    if !customization_disabled?  && SiteCustomization.custom_header.present?
      return SiteCustomization.custom_header
    end
  end

  def render_customized_footer_or_not
    if !customization_disabled? && SiteCustomization.custom_footer.present?
      return SiteCustomization.custom_footer
    end
  end

  def self.all_customtags
    Dir.glob(File.join(ENV['MEGAM_HOME'], 'site/*.html.erb'))
  end

  def self.customtag_for_site(name)

    # Don't evaluate plugins in test
    return "" if Rails.env.test?

    erbs = all_customtags.select {|c| c.include? name }
    return "" if erbs.blank?

    result = ""
    erbs.each {|erb| result << ERB.new(File.read(erb)).result }
    result.html_safe
  end

end

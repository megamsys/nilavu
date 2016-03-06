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

  def application_logo_url
    @application_logo_url ||=  SiteSetting.logo_url
  end


  def customization_disabled?
    session[:disable_customization] || SiteSetting.disable_customization
  end

  def render_customized_header_or_not
    unless customization_disabled?
      return SiteCustomization.custom_header
    end
    render partial: 'layouts/header'
  end

  def render_customized_footer_or_not
    unless customization_disabled?
      return SiteCustomization.custom_footer
    end
    render partial: 'layouts/footer'
  end

  def self.all_customtags
     Dir.glob("site/*.html.erb")
  end

  def self.customtags_for_site(name)

    # Don't evaluate plugins in test
    return "" if Rails.env.test?

    matcher = Regexp.new("/site/.*\#{name}.html\.erb$")
    erbs = all_customtags.select {|c| c =~ matcher }
    return "" if erbs.blank?

    result = ""
    erbs.each {|erb| result << render(file: erb) }
    result.html_safe
  end

end

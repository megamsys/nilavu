require 'global_exceptions'
require 'vertice_resource'
require 'auth/default_current_user_provider'

module Nilavu

  # Expected less matches than what we got in a find
  class TooManyMatches < StandardError; end

  # When they try to do something they should be logged in for
  class NotLoggedIn < StandardError; end

  # When the input is somehow bad
  class InvalidParameters < StandardError; end

  # When something they want is not found
  class NotFound < StandardError; end

  # When a setting is missing
  class SiteSettingMissing < StandardError; end

  def self.top_menu_items
    @top_menu_items ||= Nilavu.filters + [:torpedo, :app, :service]
  end

  def self.authenticators
    OmniauthCallbacksController::BUILTIN_AUTH + auth_providers.map(&:authenticator)
  end

  def self.auth_providers
    providers = []
    plugins.each do |p|
      next unless p.auth_providers
      p.auth_providers.each do |prov|
        providers << prov
      end
    end
    providers
  end

  def self.plugins
    @plugins ||= []
  end

  # Get the current base URL for the current site
  def self.current_hostname
  #  if SiteSetting.force_hostname.present?
  #    SiteSetting.force_hostname
  #  else
  #    RailsMultisite::ConnectionManagement.current_hostname
  #  end
  "localhost"
  end

  def self.base_uri(default_value = "")
    if !ActionController::Base.config.relative_url_root.blank?
      ActionController::Base.config.relative_url_root
    else
      default_value
    end
  end

  def self.base_url_no_prefix
    default_port = 80
    protocol = "http"

  #  if SiteSetting.use_https?
  #    protocol = "https"
  #    default_port = 443
  #  end

    result = "#{protocol}://#{current_hostname}"

  #  port = SiteSetting.port.present? && SiteSetting.port.to_i > 0 ? SiteSetting.port.to_i : default_port

  #  result << ":#{SiteSetting.port}" if port != default_port
    result
  end

  def self.base_url
    base_url_no_prefix + base_uri
  end

  def self.current_user_provider
    @current_user_provider || Auth::DefaultCurrentUserProvider
  end

  def self.current_user_provider=(val)
    @current_user_provider = val
  end
end

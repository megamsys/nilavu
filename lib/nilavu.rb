require_dependency 'global_exceptions'
require_dependency 'vertice_resource'
require_dependency 'auth/default_current_user_provider'
require_dependency 'version'

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

  # When they don't have permission to do something
  class InvalidAccess < StandardError
    attr_reader :obj
    def initialize(msg=nil, obj=nil)
      super(msg)
      @obj = obj
    end
  end
  
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

  #--------------
  def self.cache
    @cache ||= Cache.new
  end

  # Get the current base URL for the current site
  def self.current_hostname
    if SiteSetting.force_hostname.present?
      SiteSetting.force_hostname
    else
      'localhost'
    end
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

    if SiteSetting.use_https?
      protocol = "https"
      default_port = 443
    end

    result = "#{protocol}://#{current_hostname}"

    port = SiteSetting.port.present? && SiteSetting.port.to_i > 0 ? SiteSetting.port.to_i : default_port

    result << ":#{SiteSetting.port}" if port != default_port
    result
  end

  def self.base_url
    base_url_no_prefix + base_uri
  end

  def self.enable_readonly_mode
    $redis.set(readonly_mode_key, 1)
    MessageBus.publish(readonly_channel, true)
    keep_readonly_mode
    true
  end

  def self.keep_readonly_mode
    # extend the expiry by 1 minute every 30 seconds
    Thread.new do
      while readonly_mode?
        $redis.expire(readonly_mode_key, 1.minute)
        sleep 30.seconds
      end
    end
  end

  def self.disable_readonly_mode
    $redis.del(readonly_mode_key)
    MessageBus.publish(readonly_channel, false)
    true
  end

  def self.readonly_mode?
    recently_readonly? || !!$redis.get(readonly_mode_key)
  end

  def self.request_refresh!
    # Causes refresh on next click for all clients
    #
    # This is better than `MessageBus.publish "/file-change", ["refresh"]` because
    # it spreads the refreshes out over a time period
    MessageBus.publish '/global/asset-version', 'clobber'
  end

  def self.git_version
    return $git_version if $git_version

    # load the version stamped by the "build:stamp" task
    f = Rails.root.to_s + "/config/version"
    require f if File.exists?("#{f}.rb")

    begin
      $git_version ||= `git rev-parse HEAD`.strip
    rescue
      $git_version = Nilavu::VERSION::STRING
    end
  end

  def self.git_branch
    return $git_branch if $git_branch

    begin
      $git_branch ||= `git rev-parse --abbrev-ref HEAD`.strip
    rescue
      $git_branch = "unknown"
    end
  end

  # Either returns the site_contact_username user or the first admin.
  def self.site_contact_user
    user = User.find_by(username_lower: SiteSetting.site_contact_username.downcase) if SiteSetting.site_contact_username.present?
    user ||= (system_user || User.admins.real.order(:id).first)
  end

  SYSTEM_USER_ID ||= -1

  def self.system_user
    User.find_by(id: SYSTEM_USER_ID)
  end

  def self.store
    if SiteSetting.enable_s3_uploads?
      @s3_store_loaded ||= require 'file_store/s3_store'
      FileStore::S3Store.new
    else
      @local_store_loaded ||= require 'file_store/local_store'
      FileStore::LocalStore.new
    end
  end



  #--------------
  def self.current_user_provider
    @current_user_provider || Auth::DefaultCurrentUserProvider
  end

  def self.current_user_provider=(val)
    @current_user_provider = val
  end

  # all forking servers must call this
  # after fork, otherwise Nilavu will be
  # in a bad state
  def self.after_fork
    #SiteSetting.after_fork
    #Rails.cache.reconnect
    nil
  end

  def self.static_doc_topic_ids
    #  [SiteSetting.tos_topic_id, SiteSetting.guidelines_topic_id, SiteSetting.privacy_topic_id]
  end


end

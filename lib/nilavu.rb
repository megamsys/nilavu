require_dependency 'global_exceptions'
require_dependency 'vertice_resource'
require_dependency 'auth/default_current_user_provider'
require_dependency 'version'

module Nilavu

    # Log an exception.
    #
    # If your code is in a scheduled job, it is recommended to use the
    # error_context() method in Jobs::Base to pass the job arguments and any
    # other desired context.
    # See app/jobs/base.rb for the error_context function.
    def self.handle_job_exception(ex, context = {}, parent_logger = nil)
        context ||= {}
    end

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

    def self.assets_digest
        @assets_digest ||= begin
            digest = Digest::MD5.hexdigest(ActionView::Base.assets_manifest.assets.values.sort.join)

            digest
        end
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

    def self.display_categories
        set = Set.new

        SiteSetting.left_menu.split("|").map(&:to_s).each do |category|
            set << category
        end
        set
    end


    def self.default_categories
        set = Set.new

        SiteSetting.default_categories.split("|").map(&:to_s).each do |category|
            set << category
        end
        set
    end

    def self.default_categories_muted
        set = Set.new

        SiteSetting.default_categories_muted.split("|").map(&:to_s).each do |muted_category|
            set << muted_category
        end
        set
    end


    # Get the current base URL for the current site
    def self.current_hostname
        #if SiteSetting.force_hostname.present?
        #  SiteSetting.force_hostname
        #else
        'localhost'
        #end
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

        #  port = SiteSetting.port.present? && SiteSetting.port.to_i > 0 ? SiteSetting.port.to_i : default_port
        port  = default_port
        result << ":#{SiteSetting.port}" if port != default_port
        result
    end

    def self.base_url
        base_url_no_prefix + base_uri
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

    def self.current_user_provider
        @current_user_provider || Auth::DefaultCurrentUserProvider
    end

    def self.current_user_provider=(val)
        @current_user_provider = val
    end

    def self.current_cephuser_provider
        @current_cephuser_provider || Auth::DefaultCurrentCephUserProvider
    end

    def self.current_cephuser_provider=(val)
        @current_cephuser_provider = val
    end

    # all forking servers must call this
    # after fork, otherwise Nilavu will be in a bad state
    def self.after_fork
        SiteSetting.after_fork
        #Rails.cache.reconnect
        nil
    end
end

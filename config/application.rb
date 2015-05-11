require File.expand_path('../boot', __FILE__)
#require 'rails/all'
require "action_controller/railtie"
require "action_mailer/railtie"
#require "active_resource/railtie"
require "rails/test_unit/railtie"
require "sprockets/railtie"
require 'yaml'
require 'active_record'

#COMMON YML
if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
#  Bundler.require(:default, Rails.env)
# was used by Rails 3.2
Bundler.require(*Rails.groups(:assets => %w(development test)))
# If you want your assets lazily compiled in production, use this line
# Bundler.require(:default, :assets, Rails.env)
end

module Nilavu
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    # config.autoload_paths += %W(#{config.root}/extras)
    # Autoload lib/ folder including all subdirectories
    config.autoload_paths += Dir["#{config.root}/lib", "#{config.root}/lib/**/", "#{Rails.root}/lib", "#{Rails.root}/lib/**/"]

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Kolkata'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    # Use SQL instead of Active Record's schema dumper when creating the database.
    # This is necessary if your schema can't be completely dumped by the schema dumper,
    # like if you have constraints or database-specific column types
    # config.active_record.schema_format = :sql

    # Enforce whitelist mode for mass assignment.
    # This will create an empty whitelist of attributes available for mass-assignment for all models
    # in your app. As such, your models will need to explicitly whitelist or blacklist accessible
    # parameters by using an attr_accessible or attr_protected declaration.
    # config.active_record.whitelist_attributes = true

     #Enable the asset pipeline
    config.assets.enabled = true

    # Enable escaping HTML in JSON.
    config.active_support.escape_html_entities_in_json = true

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'

    # 404 catcher
    config.after_initialize do |app|
      app.routes.append{ match '*a', :to => 'application#render_404', via: [:get] } unless config.consider_all_requests_local
    end


    if File.exist?("#{ENV['MEGAM_HOME']}/nilavu.yml")
      common = YAML.load_file("#{ENV['MEGAM_HOME']}/nilavu.yml")                  #COMMON YML
    else
      puts "=> Warning ! MEGAM_HOME environment variable not set."
      common={"api" => {}, "storage" => {}, "varai" => {}, "auth" => {}, "monitor" => {}}
    end


    config.megam_logo_url   = "https://s3-ap-southeast-1.amazonaws.com/megampub/images/logo-megam160x43w.png"
    config.server_url       = "#{common['server']}"

    config.ganglia_web_url  = ENV['GANGLIA_WEB_URL']
    config.ganglia_host     = "#{common['monitor']['host']}" || ENV['GANGLIA_HOST']
    config.ganglia_base_url = "#{common['monitor']['base_url']}" || "http://monitor.megam.io/ganglia" || "http://localhost/ganglia"
    config.ganglia_cluster = 'megampaas'
    config.ganglia_graph_metric  = 'cpu_system'
    config.ganglia_request_metric = 'nginx_requests'
    #config.ganglia_request_metric = 'nginx_status'
    config.metric_source = "#{common['monitor']['metric_source']}"|| 'ganglia'

    if	"#{common['tap']}".chop!
    config.socket_url = "http://#{common['tap']['host']}:#{common['tap']['port']}"
    else
    config.socker_url = "http://localhost:7000"
    end

  if "#{common['storage']}".chop!
      config.storage_type =  "#{common['storage']['type']}" || 'riak'
      config.storage_crosscloud = "#{common['storage']['cloud_keys_bucket']}" || 'cloudaccesskeys'

      config.storage_sshfiles = "#{common['storage']['ssh_files_bucket']}" || 'sshfiles'
      config.storage_cloudtool =  "#{common['storage']['cloud_tool_bucket']}" || 'cloudtools'
      config.storage_server_url = "#{common['storage']['server_url']}" || 'localhost'
      config.api_server_url = "#{common['api']['host']}" || 'localhost'
      if Rails.configuration.storage_type == 's3'
        config.s3.access_key = "#{common['storage']['aws_access_key']}"
        config.s3.secret_key = "#{common['storage']['aws_secret_key']}"
      end
  else
      puts "=> Warning ! Disabled storage. Missing [storage] in nilavu.yml.I don't know where to storage."
  end

  if "#{common['auth']}".chop!
    config.fb_client_id = "#{common['auth']['fb_client_id']}" || ""
    config.fb_secret_key = "#{common['auth']['fb_secret_key']}" || ""

    config.github_client_id = "#{common['auth']['github_client_id']}" || ""
    config.github_secret_key = "#{common['auth']['github_secret_key']}" || ""

    config.assembla_client_id = "#{common['auth']['assembla_client_id']}" || ""
    config.assembla_secret_key = "#{common['auth']['assembla_secret_key']}" || ""

    config.google_client_id  = "#{common['auth']['google_client_id']}" || ""
    config.google_secret_key = "#{common['auth']['google_secret_key']}" || ""
  else
    config.fb_client_id = ""
    config.fb_secret_key =  ""
    config.github_client_id =  ""
    config.github_secret_key = ""
    config.assembla_client_id =  ""
    config.assembla_secret_key = ""
    config.google_client_id  = ""
    config.google_secret_key = ""
    puts "=> Warning ! Disabled oauth. Missing [auth] in nilavu.yml."
  end

  if "#{common['varai']}".chop!
    #designer
    config.designer_host = "#{common['varai']['host']}"
    config.designer_port = "#{common['varai']['port']}"
  else
    puts "=> Warning ! Disabled varai. Missing [varai] in nilavu.yml."
  end

  if "#{common['support']}".chop!
    #Support Service
    puts "_______________________________________________GOT SUPPORT EMAIL AND PASS __________________________________"
    config.support_email = "#{common['support']['email']}" || ""
    config.support_password = "#{common['support']['password']}" || ""
    puts config.support_email
    puts config.support_password
    puts "=============================APP.RB=============================================="
  else
    puts "=> Warning ! Disabled support email service. Missing [support] in nilavu.yml."
    config.support_email = ""
    config.support_password = ""
  end

  config.google_authorization_uri = 'https://accounts.google.com/o/oauth2/auth'
  config.google_token_credential_uri = 'https://accounts.google.com/o/oauth2/token'
  config.google_scope = 'https://www.googleapis.com/auth/userinfo.email'
  config.google_redirect_uri = 'https://www.megam.co/auth/google_oauth2/callback'

 #website link for banner text - http://patorjk.com/software/taag/#p=display&f=ANSI%20Shadow&t=Nilavu
    puts """\033[35m
                  _..._       ███╗   ██╗██╗██╗      █████╗ ██╗   ██╗██╗   ██╗
                .::'   `.     ████╗  ██║██║██║     ██╔══██╗██║   ██║██║   ██║
               :::       :    ██╔██╗ ██║██║██║     ███████║██║   ██║██║   ██║
               :::       :    ██║╚██╗██║██║██║     ██╔══██║╚██╗ ██╔╝██║   ██║
               `::.     .'    ██║ ╚████║██║███████╗██║  ██║ ╚████╔╝ ╚██████╔╝
                 `':..-'      ╚═╝  ╚═══╝╚═╝╚══════╝╚═╝  ╚═╝  ╚═══╝   ╚═════╝


  \033[0m"""


  end
end

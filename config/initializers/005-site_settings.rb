# load up git version into memory
# this way if it changes underneath we still have
# the original version
Nilavu.git_version
#
reload_settings = lambda {
  begin
    SiteSetting.refresh!
    Rails.logger.debug ''"\033[1m\033[36msite_settings.yml loaded.\033[0m"''
    if Rails.env.development?
      Rails.logger.debug ''"\033[1m\033[33m
     #{SiteSetting.settings_hash.to_yaml}\033[0m"''
    end
  rescue => e
    if Rails.env.development?
      STDERR.puts e.backtrace
    end
    STDERR.puts "URGENT: #{e} Failed to initialize site_settings.yml"
    # the show must go on, don't stop startup if site load fails
  end
}

if Rails.configuration.cache_classes
  reload_settings.call
else
  ActionDispatch::Reloader.to_prepare do
    reload_settings.call
  end
end

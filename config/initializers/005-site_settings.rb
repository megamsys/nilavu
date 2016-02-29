# load up git version into memory
# this way if it changes underneath we still have
# the original version
Nilavu.git_version
#
reload_settings = lambda {
    begin
      SiteSetting.refresh!
      puts SiteSetting.settings_hash.to_yaml
    rescue => e
      STDERR.puts e.backtrace
      STDERR.puts "URGENT: #{e} Failed to initialize site"
      # the show must go on, don't stop startup if multisite fails
    end
}

if Rails.configuration.cache_classes
  reload_settings.call
else
  ActionDispatch::Reloader.to_prepare do
    reload_settings.call
  end
end

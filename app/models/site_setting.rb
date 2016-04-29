require 'site_setting_extension'
require_dependency 'site_settings/yaml_loader'

require_dependency 'current_user'


class SiteSetting
  extend SiteSettingExtension
  include CurrentUser

  def self.load_settings(file)
    SiteSettings::YamlLoader.new(file).load do |category, name, default, opts|
      if opts.delete(:client)
        client_setting(name, default, opts.merge(category: category))
      else
        setting(name, default, opts.merge(category: category))
      end
    end
  end

  load_settings(File.join(ENV['MEGAM_HOME'], 'site_settings.yml'))

  client_settings << :available_locales

  def self.available_locales
    LocaleSiteSetting.values.map{ |e| e[:value] }.join('|')
  end

  def self.top_menu_items
    top_menu.split('|').map { |menu_item| TopMenuItem.new(menu_item) }
  end

  
  def self.homepage
    top_menu_items[0].name
  end


  def self.scheme
    use_https? ? "https" : "http"
  end

end

require 'site_setting_extension'
require 'flavor/favour_item'
require_dependency 'site_settings/yaml_loader'

class SiteSetting
  extend SiteSettingExtension

  #def self.after_save do |site_setting|
  #  NilavuEvent.trigger(:site_setting_saved, site_setting)
  #  true
  #end

  def self.load_settings(file)
    SiteSettings::YamlLoader.new(file).load do |category, name, default, opts|
      if opts.delete(:client)
        client_setting(name, default, opts.merge(category: category))
      else
        setting(name, default, opts.merge(category: category))
      end
    end
  end

  load_settings(File.join(Rails.root, 'config', 'site_settings.yml'))

  unless Rails.env.test? && ENV['LOAD_PLUGINS'] != "1"
    Dir[File.join(Rails.root, "plugins", "*", "config", "settings.yml")].each do |file|
      load_settings(file)
    end
  end

  client_settings << :available_locales

  def self.available_locales
    LocaleSiteSetting.values.map{ |e| e[:value] }.join('|')
  end

  def self.domain_name
    #current_user.team.last_used_domain
    "megambox.com"
  end


  def self.top_menu_items
    top_menu.split('|').map { |menu_item| TopMenuItem.new(menu_item) }
  end

  def self.favourize_for_vm_items
    flavors.split('|').map { |favorize_item| FavourizeItem.new(favorize_item) }
  end

  def self.favourize_for_cs_items
    flavors_cs.split('|').map { |favorize_item| FavourizeItem.new(favorize_item) }
  end


  def self.homepage
    top_menu_items[0].name
  end


  def self.scheme
    use_https? ? "https" : "http"
  end

end

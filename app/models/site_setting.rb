require 'site_setting_extension'
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
    current_user.team.last_used_domain
  end


  def self.top_menu_items
    top_menu.split('|').map { |menu_item| TopMenuItem.new(menu_item) }
  end

  def self.favourize_for_vm_items
    flavours.split('|').map { |favorize_item| FavourizeItem.new(favorize_item) }
  end

  def self.favourize_for_container_items
    flavours_cs.split('|').map { |favorize_item| FavourizeItem.new(favorize_item) }
  end


  def self.homepage
    top_menu_items[0].name
  end


  def self.should_download_images?(src)
    setting = disabled_image_download_domains
    return true unless setting.present?

    host = URI.parse(src).host
    return !(setting.split('|').include?(host))
  rescue URI::InvalidURIError
    return true
  end

  def self.scheme
    use_https? ? "https" : "http"
  end

end

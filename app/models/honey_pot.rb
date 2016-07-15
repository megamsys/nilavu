require 'launchable_item'

class HoneyPot

  def self.cached_marketplace_by_item(params)
    marketplace_item = find_by(params)

    if marketplace_item
      return  LaunchableItem.new(params, marketplace_item)
    end
  end

  # groups with cattypes (Collaboration...)
  def self.cached_marketplace_groups(params)
    Rails.cache.fetch("honeypot", race_condition_ttl: 20) do
      Api::Marketplaces.instance.list(params).marketplace_groups
    end
  end

  # groups with settings_name (vertice, bitnami, containership...)
  # race_condition_ttl is needed  (RTFM - https://github.com/megamsys/nilavu/issues/943)
  def self.cached_marketplace_bifurs(params)
    Rails.cache.fetch("honeypot_bifurs", race_condition_ttl: 20) do
      Api::Marketplaces.instance.list(params).marketplace_bifurs
    end
  end

  private

  def self.find_by(params)
    Rails.cache.fetch("honeypot_#{params['id']}",race_condition_ttl: 20) do
      Api::Marketplaces.instance.show(params).item
    end
  end
end

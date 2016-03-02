require 'ready_launch'

class HoneyPot

  def self.cached_marketplace_by_item(params)
    marketplace_item = find_by(params)
    
    if marketplace_item
      return  ReadyLaunch.new(params, marketplace_item)
    end
  end

  def self.cached_marketplace_groups(params)
    Rails.cache.fetch("honey_pot", expires_in: 10.minutes) do
      Api::Marketplaces.instance.list(params).marketplace_groups
    end
  end

  private

  def self.find_by(params)
    Rails.cache.fetch("honey_pot_#{params[:name]}", expires_in: 10.minutes) do
      Api::Marketplaces.instance.show(params).item
    end
  end
end

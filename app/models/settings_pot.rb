class SettingsPot

    def self.cached_regions(params={})
        self.cache_regions
    end

    private
    def self.cache_regions
        Rails.cache.fetch("regions", expires_in: 10.minutes) do
            Regions.refresh!
        end
    end
end

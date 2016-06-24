class CustomAppsScrubber < Scrubber


    APP                 =  '2'.freeze

    CATTYPES            =  [APP]


    def name
        "customapps"
    end

    def scrubbed
        convert_launchable_items

        h2 = @data.map do |k, v|
            v.map do  |m|
                LaunchableItem.new(m)
            end
        end

        @data = h2
    end

    def after_scrubbed
        @data.flatten.map do |launchable_item|
            launchable_item.to_h
        end
    end

    def register_honeypot(params)
        @data = HoneyPot.cached_marketplace_groups(params).dup
    end

    protected

    def convert_launchable_items
        @data.select! do |key, marketplace_collection|
            CATTYPES.include?(key)
        end
    end
end

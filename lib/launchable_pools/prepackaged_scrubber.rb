class PrepackagedScrubber < Scrubber

    attr_accessor :cleansers

    def name
        "prepackaged"
    end

    def bifurs
        @cleansers ||= {}
        %w(bitnami vertice).map do |provider|
            next if provider.blank?
            PrepackagedScrubber.advanced_cleansers.each do |cleanse_provider, block|
                if provider == cleanse_provider
                    @cleansers[provider.to_sym] = block
                end
            end
        end
    end

    def scrubbed
        clean_data = process_advanced_cleansing!
        h2 = clean_data.map do |k, v|
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
        @data = HoneyPot.cached_marketplace_bifurs(params)
    end

    def self.advanced_cleanser(trigger,&block)
        (@advanced_cleansers ||= {})[trigger] = block
    end

    def self.advanced_cleansers
        @advanced_cleansers
    end

    advanced_cleanser('bitnami') do |dirtly_data, subfilter|
        dirtly_data
    end

    advanced_cleanser('vertice') do |dirtly_data, subfilter|
        dirtly_data.select! do |items|
            items.select! do |it|
                it.options.select{|i| i['key'] == 'oneclick'}.length > 0 || it.cattype == 'SERVICE'
            end if items.is_a?(Array)
        end.unshift('vertice')
    end

    protected

    def convert_dirtly(dirtly_key)
        @data.select do |key, marketplace_collection|
            dirtly_key == key.to_sym
        end
    end


    def process_advanced_cleansing!
        cleansed = []
        bifurs

        @cleansers.each do |provider, block|
            dirty_data = convert_dirtly(provider).first

            dirty_data = instance_exec(dirty_data, "subfilter", &block) || dirty_data

            cleansed << dirty_data
        end if @cleansers
        cleansed.reject(&:blank?)
    end

end

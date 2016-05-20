class MarketplacePoolGroups

    BUILTIN_SCRUB = [
        Auth::VirtualMachinesScrubber.new,
        Auth::ContainersScrubber.new,
        Auth::PrepackagedScrubber.new,
        Auth::CustomAppsScrubber.new
    ]


    def self.groups
        Hash[BUILTIN_SCRUB.map { |x| [x.name.to_sym, x] }]
    end

    def self.find_by_groups(params, choices)
        choices.map {|x| self.find_by_group(params, x)}
    end

    def self.find_by_group(params, choice)
        the_group = find_by(params,choice)

        if the_group
            return  the_group.after_create_output
        end
    end

    private

    def self.find_by(params, by_scrubber)
        filter(HoneyPot.cached_marketplace_groups(params), by_scrubber)
    end

    def self.filter(data,by_scrubber)
        Nilavu.scrubbers.select do |scrubber|
            if scrubber.name == by_scrubber
                scrubber.register(data)
            end
        end
    end

end

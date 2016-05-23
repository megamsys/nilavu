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
        the_group = find_by(choice, params)

        the_group.scrubbed                       #parse

        if the_group
            return  the_group.after_scrubbed     # build hash
        end
    end

    private

    def self.find_by(scrubber_name, params)
        filter(HoneyPot.cached_marketplace_groups(params), scrubber_name)
    end

    def self.filter(honeypot_data,scrubber_name)
        BUILTIN_SCRUB.select do |scrubber|
            if scrubber.name.to_sym == scrubber_name
                scrubber.register_honeypot(honeypot_data)
            end
        end
    end

end

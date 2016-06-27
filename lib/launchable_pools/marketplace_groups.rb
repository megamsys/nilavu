require 'virtualmachines_scrubber'
require 'containers_scrubber'
require 'prepackaged_scrubber'
require 'customapps_scrubber'

module MarketplaceGroups

    BUILTIN_SCRUB = [
        VirtualMachinesScrubber.new,
        PrepackagedScrubber.new,
        CustomAppsScrubber.new
#        ContainersScrubber.new
    ]


    def self.groups
        Hash[BUILTIN_SCRUB.map { |x| [x.name.to_sym, x] }]
    end

    def self.find_by_groups(params, choices)
        choices.map {|x| self.find_by_group(params, x)}
    end

    def self.find_by_group(params, choice)
        the_group = find_by(choice, params)

        the_scrubber ||= the_group.first                       #parse

        if the_scrubber
            the_scrubber.scrubbed
            return  the_scrubber.after_scrubbed     # build hash
        end
    end

    private

    def self.find_by(scrubber_name, params)
        filter(params, scrubber_name)
    end

    def self.filter(params,scrubber_name)
        BUILTIN_SCRUB.select do |scrubber|
            if scrubber.name.to_sym == scrubber_name
                scrubber.register_honeypot(params)
            end
        end
    end

end

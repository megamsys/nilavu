module LaunchableScrubber
   include MarketplaceGroups

    def virtualmachines(params)
        MarketplaceGroups.find_by_group(params,:virtualmachines)
    end

    def prepackaged(params)
        MarketplaceGroups.find_by_group(params,:prepackaged)
    end

    def containers(params)
        MarketplaceGroups.find_by_group(params,:containers)
    end

    def customapps(params)
        MarketplaceGroups.find_by_group(params, :customapps)
    end

    def snapshots(params)
        return Hash[]
    end

    def scrub(params)
        {
            virtualmachines: virtualmachines(params),
            prepackaged: prepackaged(params),
            containers: containers(params),
            customapps: customapps(params),
            snapshots: snapshots(params)
        }
    end
end

module LaunchablePreparer
  include MarketplacePoolGroups

    def virtualmachines(params)
        find_by_group(params,:virtualmachines)
    end

    def prepackaged(params)
        find_by_group(params,:prepackaged)
    end

    def containers(params)
        find_by_group(params,:containers)
    end

    def customapps(params)
        find_by_group(params, :customapps)
    end

    def snapshots(params)
        return Hash[]
    end

    def prepared(params)
        {
            virtualmachines: virtualmachines(params),
            prepackaged: prepackaged(params),
            containers: containers(params),
            customapps: customapps(params),
            snapshots: snapshots(params)
        }
    end
end

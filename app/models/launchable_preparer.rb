module LaunchablePreparer
  include MarketplacePoolGroups

    def virtualmachines
        find_by_group(:virtualmachines)
    end

    def prepackaged
        find_by_group(:prepackaged)
    end

    def containers
        find_by_group(:containers)
    end

    def customapps
        find_by_group(:customapps)
    end

    def snapshots
        return Hash[]
    end

    def prepared
        {
            virtualmachines: virtualmachines,
            prepackaged: prepackaged,
            containers: containers,
            customapps: customapps,
            snapshots: snapshots
        }
    end
end

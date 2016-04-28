module LaunchableAssembler

    def reload_cached_item!
        SettingsPot.cached_regions
    end

    def regions
        reload_cached_item!
    end

    def generate_random_name
        random_name = /\w+/.gen.downcase
    end

    def domain
        current_user.team.last_used_domain.name
    end

    def currency_denoted
        #    SiteSetting.currency
        '\u20B9'
    end

    def assembled
        {
            regions: regions,
            random_name: generate_random_name,
            domain: domain,
            currency_denoted: currency_denoted,
        }
    end
end

module CurrentBilly

    def lookup_billy_addon
        billy = Billy.new
        billy_params.each { |k, v| billy.send("#{k}=", v) }

        if billy = billy.find_by_email(params)
            unless billy.has_credentials?
                invalid_credentials
                return
            end
        else
            invalid_credentials
            return
        end
    end

    private

    def invalid_credentials
        render json: {error: I18n.t("errors.not_onboarded_in_biller")}
    end

    def billy_params
        {:provider => SiteSetting.enabled_biller}
    end
end

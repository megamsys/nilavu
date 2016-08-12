module CurrentBilly

    def lookup_external_id_in_addons(params)
        billy = Billy.new
        billy_params.each { |k, v| billy.send("#{k}=", v) }

        if billy = billy.find_by_email(params)
            unless billy.has_external_id?
                return no_external_id_found
            end
        else
            return no_external_id_found
        end
    end

    private

    def no_external_id_found
      #  render json: {error: I18n.t("errors.not_found", provider: billy_params[:provider])}
        {:success => false, :error => "user.activation.addon_not_found"}
    end

    def billy_params
        {:provider => SiteSetting.enabled_biller}
    end
end

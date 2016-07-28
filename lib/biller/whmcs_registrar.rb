require 'digest/md5'

module WHMCSRegistrar
    def name
        "whmcs"
    end

    def register
        configuration_valid?

        WHMCS.configure do |config|
            config.api_url      = SiteSetting.whmcs_api_url
            config.api_username = SiteSetting.whmcs_username
            config.api_password = Digest::MD5.hexdigest(SiteSetting.whmcs_password)
        end
    end

    private

    def configuration_valid?
        raise Nilavu::NotFound("WHMCS configuration missing, require: (url/username, password) in site_settings.yml") unless SiteSetting.whmcs_api_url && SiteSetting.whmcs_username && SiteSetting.whmcs_password
    end
end

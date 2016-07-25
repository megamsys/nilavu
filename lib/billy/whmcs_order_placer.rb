require 'whmcs'
require 'digest/md5'

class Billy::WHMCSOrderPlacer < Billy::OrderPlacer

    def name
        "whmcs"
    end

    #:clientid
    def order(order_options)
      WHMCS::Client.add_order(order_options)
    end

    def after_order(user, order)
        result = Billy::Result.new
        puts "----------- order "
        puts order.inspect
        result.id = order[:id]
        fraud_check = WHMCS::Client.add_order(order_options)
        return result unless fraud_check
        puts "----------- fraud check "
        puts fraud_check.inspect
        result.fraud_check = fraud_check
        result.redirect = WHMCSAutoAuth.redirect_url(user.email)
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

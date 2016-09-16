require 'whmcs'

class Biller::WHMCSShopper < Biller::Shopper
    include Biller::WHMCSRegistrar

    def initialize
        register
    end

    def shop(shop_options = {})
        WHMCS::Order.get_products(shop_options).attributes['whmcsapi']
    rescue StandardError => se
        { result: 'error', error: 'errors.desc.not_found' }
    end

    def after_shop(shopped)
        result = Biller::Result.new
        shopped.each { |k, v| result.send("#{k}=", v) }
        result.to_hash
        if result.to_hash[:result] == 'success'
            begin
              WHMCS::Invoice.get_payment_methods.attributes['whmcsapi']
          rescue StandardError => se
              { result: 'error', error: 'errors.desc.not_found' }
          end
        else
            { result: 'error', error: 'errors.desc.not_found' }
      end
    end
end

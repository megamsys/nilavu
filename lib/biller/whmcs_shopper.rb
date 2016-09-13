require 'whmcs'

class Biller::WHMCSShopper < Biller::Shopper
    include Biller::WHMCSRegistrar

    def initialize
      register
    end

    def shop(shop_options={})
      begin
        WHMCS::Order.get_products(shop_options).attributes
      rescue StandardError => se
          {:result => "error", :error => "errors.desc.not_found"}
      end
    end

    def after_shop()
        begin
        WHMCS::Invoice.get_payment_methods().attributes
        rescue StandardError => se
          {:result => "error", :error => "errors.desc.not_found"}
      end
    end
end

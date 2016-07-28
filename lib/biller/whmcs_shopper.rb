require 'whmcs'

class Biller::WHMCSShopper < Billy::Shopper
    include WHMCSRegistrar

    def shop(shop_options)
        WHMCS::Client.get_products(shop_options)
    end

    def after_shop(user, shopped)
        result = Biller::Result.new
        puts "----------- shopped "
        puts shopped.inspect
        puts "----------- shopped..."
        payment_methods = WHMCS::Client.get_payment_methods(shopped)
        return result unless payment_methods
        puts "----------- payment_methods"
        puts payment_methods.inspect
        puts "----------- payment_methods..."

    end
end

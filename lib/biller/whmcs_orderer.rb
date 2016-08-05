require 'whmcs'
require 'digest/md5'

class Biller::WHMCSOrderer < Billy::Orderer
    include WHMCSRegistrar
    include WHMCSAutoAuth

    #:clientid
    def order(order_options)
        WHMCS::Client.add_order(order_options)
    end

    def after_order(user, ordered)
        result = Billy::Result.new
        puts "----------- ordered"
        puts ordered.inspect
        puts "----------- ordered..."
        result.id = ordered[:id]
        fraud_checked = WHMCS::Client.order_fraud_check(ordered)
        return result unless fraud_checked
        puts "----------- fraud checked "
        puts fraud_checked.inspect
        result.fraud_checked = fraud_checked
        puts "----------- fraud checked..."
        result.redirect = WHMCSAutoAuth.redirect_url(user.email)
    end
end

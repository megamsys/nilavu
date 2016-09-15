require 'whmcs'
require 'digest/md5'

class Biller::WHMCSOrderer < Biller::Orderer
    include Biller::WHMCSRegistrar
    include Biller::WHMCSAutoAuth

    def initialize
      register
    end
    #:clientid
    def order(order_options)
        WHMCS::Order.add_order(order_options).attributes
    end

    def after_order(ordered)
      ordered[:action] = 'orders'
        result = Biller::Result.new
        result.id = ordered[:id]
        result.email = ordered[:email]
        result.action = ordered[:action]
        fraud_checked = WHMCS::Order.fraud_order(ordered)
        return result unless fraud_checked
        result.fraud_checked = fraud_checked
        result.redirect = Biller::WHMCSAutoAuth.redirect_url(result.email,result.action)
    end
end

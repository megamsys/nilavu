require 'whmcs'
require 'digest/md5'

class Biller::WHMCSOrderer < Biller::Orderer
    include Biller::WHMCSRegistrar
    include Biller::WHMCSAutoAuth

    ACTION_ORDERS = "orders".freeze

    def initialize
        register
    end

    #:clientid
    def order(order_options)
        WHMCS::Order.add_order(order_options)
    rescue StandardError => se
        { result: 'error', error: 'errors.billing.error' }
    end

  def after_order(ordered, email)
      result = Biller::Result.new
      ordered.attributes.each { |k, v| result.send("#{k}=", v) }
      success?(result) ? build_redirection_url(result, email) : { result: 'error', error: 'billing.order_creation_error' }
  end

  private

def success?(result)
    result.to_hash[:result] == 'success'
end

def build_redirection_url(ordered, email)
      checked = fraud_check(ordered)
      Biller::WHMCSAutoAuth.redirect_url(email, ACTION_ORDERS) if checked[:result]
end

def  fraud_check(ordered)
   return fraud_check_successful unless SiteSetting.whmcs_fraud_check
   begin
       WHMCS::Order.fraud_order(ordered)
       fraud_check_successful
   rescue StandardError => se
       { result: false}
   end

end

def fraud_check_successful
    {result: true}
end
end

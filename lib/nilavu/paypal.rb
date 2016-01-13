##
## Copyright [2013-2016] [Megam Systems]
##
## Licensed under the Apache License, Version 2.0 (the "License");
## you may not use this file except in compliance with the License.
## You may obtain a copy of the License at
##
## http://www.apache.org/licenses/LICENSE-2.0
##
## Unless required by applicable law or agreed to in writing, software
## distributed under the License is distributed on an "AS IS" BASIS,
## WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
## See the License for the specific language governing permissions and
## limitations under the License.
##
module Nilavu
class Paypal
  include PayPal::SDK::REST

  def self.generate_url(params)
    payment = Payment.new(intent: 'sale',

    # ###Payer
    # A resource representing a Payer that funds a payment
    # Payment Method as 'paypal'
    payer: {
      payment_method: 'paypal' },
      # ###Redirect URLs
      redirect_urls: {
        return_url: "#{Ind.nilavu}/notify_payment",
        cancel_url: "#{Ind.nilavu}" },

      # ###Transaction
      # A transaction defines the contract of a
      # payment - what is the payment for and who
      # is fulfilling it.
      transactions: [{
      # ###Amount
      # Let's you specify a payment amount.
      amount: {
        total: params['amount'].to_s,
        currency: 'USD'
        },
      description: 'This is the payment transaction description.' }])

    # Create Payment and return status
    if payment.create
      # Redirect the user to given approval url
      return payment.links.find { |v| v.method == 'REDIRECT' }.href
    end
  rescue StandardError => se
  end

  def self.execute(params)
    payment = Payment.find(params['paymentId'])
    # PayerID is required to approve the payment.
    if payment.execute(payer_id: params['PayerID']) # return true or false
      return payment.transactions[0].amount.total.to_s
    end
  rescue StandardError => se
  end
end
end

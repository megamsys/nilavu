##
## Copyright [2013-2015] [Megam Systems]
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
class BillingsController < ApplicationController
  respond_to :html, :js
  include Packable
  include PayPal::SDK::REST
  def index
    @currencies = ["USD", "IN"]
     @bill_collection = GetBalance.perform(force_api[:email], force_api[:api_key])
      if @bill_collection.class == Megam::Error
         logger.info @bill_collection.inspect
         redirect_to main_dashboards_path, :gflash => { :warning => { :value => "API server may be down. Please contact #{ActionController::Base.helpers.link_to 'support !.', "http://support.megam.co/", :target => "_blank"}.", :sticky => false, :nodom_wrap => true } }
      else    
        @billinghistories_collection = ListBillingHistories.perform(force_api[:email], force_api[:api_key])
        if @billinghistories_collection.class == Megam::Error
           logger.info @billinghistories_collection.inspect
           redirect_to main_dashboards_path, :gflash => { :warning => { :value => "API server may be down. Please contact #{ActionController::Base.helpers.link_to 'support !.', "http://support.megam.co/", :target => "_blank"}.", :sticky => false, :nodom_wrap => true } }
        else
           @bill = @bill_collection.lookup(force_api[:email])
           puts "+++++++++++++++++++++++++++++++++++++++++++++"
           puts @billinghistories.inspect
          #@bill.credit.to_i 
        end  
      end  
  end

  def payment_execute  
    @payment = Payment.find(params["paymentId"])    
    # PayerID is required to approve the payment.
    if @payment.execute( :payer_id => params["PayerID"] )  # return true or false
      logger.info "Payment[#{@payment.id}] execute successfully"
      @bill_collection = GetBalance.perform(force_api[:email], force_api[:api_key])
      if @bill_collection.class == Megam::Error
         logger.info @bill_collection.inspect
         redirect_to main_dashboards_path, :gflash => { :warning => { :value => "API server may be down. Please contact #{ActionController::Base.helpers.link_to 'support !.', "http://support.megam.co/", :target => "_blank"}.", :sticky => false, :nodom_wrap => true } }
      else
        @bill = @bill_collection.lookup(force_api[:email])       
        puts @bill.credit.to_i + @payment.transactions[0].amount.total.to_i
         options = { :id => @bill.id, :accounts_id => @bill.accounts_id, :name => @bill.name, :credit => @bill.credit.to_i + @payment.transactions[0].amount.total.to_i, :created_at => @bill.created_at, :updated_at => @bill.updated_at }
         res_body = UpdateBalance.perform(options, force_api[:email], force_api[:api_key])
         if res_body.class == Megam::Error
            logger.info res_body.inspect
            redirect_to main_dashboards_path, :gflash => { :warning => { :value => "API server may be down. Please contact #{ActionController::Base.helpers.link_to 'support !.', "http://support.megam.co/", :target => "_blank"}.", :sticky => false, :nodom_wrap => true } }
         else
            redirect_to billings_path
         end
      end       
    else
       logger.error @payment.error.inspect
       redirect_to main_dashboards_path, :gflash => { :warning => { :value => "PayPal transaction got error. Please contact #{ActionController::Base.helpers.link_to 'support !.', "http://support.megam.co/", :target => "_blank"}.", :sticky => false, :nodom_wrap => true } }
    end
  end

  def pay
    # ###Payment
    # A Payment Resource; create one using
    # the above types and intent as 'sale'
    @payment = Payment.new({
  :intent =>  "sale",

  # ###Payer
  # A resource representing a Payer that funds a payment
  # Payment Method as 'paypal'
  :payer =>  {
    :payment_method =>  "paypal" },

  # ###Redirect URLs
  :redirect_urls => {
    :return_url => "https://#{Rails.configuration.server_url}/payment_execute",
    :cancel_url => "https://#{Rails.configuration.server_url}" },

  # ###Transaction
  # A transaction defines the contract of a
  # payment - what is the payment for and who
  # is fulfilling it.
  :transactions =>  [{

    # Item List
   # :item_list => {
   #   :items => [{
   #     :name => "item",
    #    :sku => "item",
    #    :price => "5",
     #   :currency => "USD",
     #   :quantity => 1 }]},

    # ###Amount
    # Let's you specify a payment amount.
    :amount =>  {
      :total =>  "5",
      :currency =>  "USD" 
      },
    :description =>  "This is the payment transaction description." }]})

    # Create Payment and return status
    if @payment.create
      # Redirect the user to given approval url
      @redirect_url = @payment.links.find{|v| v.method == "REDIRECT" }.href
      logger.info "Payment[#{@payment.id}]"
      logger.info "Redirect: #{@redirect_url}"
      redirect_to @redirect_url
    else
      logger.error @payment.error.inspect
      redirect_to billings_path, :gflash => { :warning => { :value => "Error occured - #{@payment.error.inspect}. Please contact #{ActionController::Base.helpers.link_to 'support !.', "http://support.megam.co/", :target => "_blank"}.", :sticky => false, :nodom_wrap => true } }
    end
  end

end
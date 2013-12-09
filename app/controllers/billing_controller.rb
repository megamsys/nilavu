class BillingController < ApplicationController
  
  FREE_PLAN = "FREE"
  LITE_PLAN = "LITE"
  STANDARD_PLAN = "STANDARD"
  PRO_PLAN = "PRO"
  def pricing
    add_breadcrumb "Pricing", pricing_path
  end

  def account
    add_breadcrumb "Account", account_path
  end

  def history
    add_breadcrumb "History", history_path
  end

  def upgrade
    puts ""
    puts "********************************************************************"
    puts "** CREATE CUSTOMER ON THE FREE PLAN **"
    puts "********************************************************************"

    # create a customer on a free plan
    data = {
      :code => current_user.first_name,
      :firstName => current_user.first_name,
      :lastName => current_user.last_name,
      :email => current_user.email,
      :subscription => {
        :planCode => 'FREE'
      }
    }

    client = getclient
    response = client.new_customer(data)
    puts response
    if response.valid?
      puts "\tCreated Milton Waddams with code=MILTON_WADDAMS"
    else
      puts "\tERROR: #{response.error_messages.inspect}"
    end
  end

  def getclient
    client = CheddarGetter::Client.new(
    :product_code => Rails.configuration.ched_prod_code,
    :username => Rails.configuration.ched_user_name,
    :password => Rails.configuration.ched_password
    )
    client
  end

  def invoice
    client = getclient
    puts "========================="
    response = client.get_customer(:code => 'BILL_LUMBERG')
    if response.valid?
      customer = response.customer
      subscription = response.customer_subscription
      plan = response.customer_plan
      invoice = response.customer_invoice

      puts "\t#{customer[:firstName]} #{customer[:lastName]}"
      puts "\tPricing Plan: #{plan[:name]}"
      puts "\tPending Invoice Scheduled: #{invoice[:billingDatetime].strftime('%m/%d/%Y')}"
      invoice[:charges].each do |charge|
        puts "\t\t(#{charge[:quantity]}) #{charge[:code]} $#{charge[:eachAmount]*charge[:quantity]}"
      end
    else
      puts "\tERROR: #{response.error_messages.inspect}"
    end
  end

end

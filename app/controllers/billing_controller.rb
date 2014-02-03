class BillingController < ApplicationController

  FREE_PLAN = "FREE"
  LITE_PLAN = "LITE"
  STANDARD_PLAN = "STANDARD"
  PRO_PLAN = "PRO"
  
  def pricing
    breadcrumbs.add "Pricing", pricing_path
  end

  def account
    breadcrumbs.add "Account", account_path
  end

  def history
    breadcrumbs.add "History", history_path
  end

  def upgrade
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
    if response.valid?
      logger.debug "\tCreated Milton Waddams with code=MILTON_WADDAMS"
    else
      logger.error "\tERROR: #{response.error_messages.inspect}"
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
    response = client.get_customer(:code => 'BILL_LUMBERG')
    if response.valid?
      customer = response.customer
      subscription = response.customer_subscription
      plan = response.customer_plan
      invoice = response.customer_invoice

      logger.debug "\t#{customer[:firstName]} #{customer[:lastName]}"
      logger.debug "\tPricing Plan: #{plan[:name]}"
      logger.debug "\tPending Invoice Scheduled: #{invoice[:billingDatetime].strftime('%m/%d/%Y')}"
      invoice[:charges].each do |charge|
        logger.debug "\t\t(#{charge[:quantity]}) #{charge[:code]} $#{charge[:eachAmount]*charge[:quantity]}"
      end
    else
      logger.error "\tERROR: #{response.error_messages.inspect}"
    end
  end

end

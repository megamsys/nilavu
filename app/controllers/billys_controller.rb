require 'current_billableuser'

class BillyController < ApplicationController
    include CurrentBillableUser

    before_action :add_authkeys_for_api, only: [:index, :show]

    def show
        render json: {saved_subscriptions: savedsubs, order_inputs: order_input}
    end

    # create an order
    def create
      #Orderer
    end

    def order_created
        Api::Subscriptions.new.create(params)
    end

    def modify_order
    end


    private

    def order_inputs
        # payment_methods, get_products
    end

    def savedsubs
        Api::Subscriptions.new.show(params)
    end
end

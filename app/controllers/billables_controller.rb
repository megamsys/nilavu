require 'current_billableuser'

class BillablesController < ApplicationController
    include CurrentBillableUser

    # onboard billing address
    def create
    end

    # subscribe  to a plan (ondemand/recurring)
    def subscribe
    end

    def order_created
    end


    #fraud check on onder
    def perform_fraudcheck
    end

    # unsubscribe  to a plan (ondemand/recurring)
   def unsubscribe
   end

   def change_subscription
   end
end

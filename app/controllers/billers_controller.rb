require 'current_billableuser'

class BillersController < ApplicationController
    include CurrentBillableUser

    before_action :add_authkeys_for_api, only: [:index, :show]

    def show
        billy = Billy.new
        billy_params.each { |k, v| billy.send("#{k}=", v) }

        if billy = billy.find_by_email
            unless billy.has_credentials?
                invalid_credentials
                return
            end
        else
            invalid_credentials
            return
        end

        render json: {shopper: shopper || {}}
    end

    def create
        billy = Billy.new
        billy_params.each { |k, v| billy.send("#{k}=", v) }

        if billy = billy.find_by_email
            unless billy.has_credentials?
                invalid_credentials
                return
            end
        else
            invalid_credentials
            return
        end

        render json: {order: order || {}}
    end

    def order_created
        Api::Subscriptions.new.create(params)
    end


    private

    def invalid_credentials
        render json: {error: I18n.t("errors.not_onboarded_in_biller")}
    end

    def shopper
        if bildr = bildr_processe_is_ready(SHOPPER_PROCESSE)
            b = bildr.shopper.shop

            bildr.shopper.after_shop(b)
        end
    end

    def order
        if bildr = bildr_processe_is_ready(ORDER_PROCESSE)
            b = bildr.subscriber.order

            bildr.subscriber.after_order(b)
        end
    end

    def bildr_processe_is_ready(processe)
        bildr = Biller::Builder.new(processe)

        return unless bildr && obj.respond_to?(processe.downcase.to_sym)

        bildr
    end
end

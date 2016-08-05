class BillersController < ApplicationController
    include CurrentBilly

    before_action :add_authkeys_for_api, only: [:index, :show]

    def show
        render json: {shopper: shopper || {}}
    end

    def create
        render json: {order: order || {}}
    end

    def order_created
        if sub =   Api::Subscriptions.new.create(params)
            render json: success_json
        else
            render json: {error: I18n.t("login.incorrect_email_or_password")}
        end
    end


    private

    def invalid_credentials
        render json: {error: I18n.t("errors.not_onboarded_in_biller")}
    end

    def shopper
        l = lookup_billy_addon(params)

        if bildr = bildr_processe_is_ready(SHOPPER_PROCESSE)
            b = bildr.orderer.shop(l)

            bldr.orderer.after_shop(b)
        end
    end

    def order
        l = lookup_billy_addon(params)

        if bildr = bildr_processe_is_ready(ORDERER_PROCESSE)
            b = bildr.orderer.order(l)

            bldr.orderer.after_order(b)
        end
    end

    def bildr_processe_is_ready(processe)
        bildr = Biller::Builder.new(processe)

        return unless bildr && obj.respond_to?(processe.downcase.to_sym)

        bildr
    end
end

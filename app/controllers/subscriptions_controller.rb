class SubscriptionsController < ApplicationController
    include CurrentBilly

    before_action :add_authkeys_for_api, only: [:entrance, :create]

    def entrance
        ua = UserActivationChecker.new

        return "/" if ua.check_activation_completed?

        lookup_billy_addon

        render json: {subscriber: subscriber || {}, phone_activation: ua.activating_mobile_avatar}
    end

    # subcriber to update the billing address
    def create
        lookup_billy_addon

        render json: {subscriber: update_subscriber || {}}
    end

    private

    def subscriber
        if bildr = bildr_processe_is_ready(SUBSCRIBER_PROCESSE)
            processe_run = bildr.subscriber.subscribe

            bldr.subscriber.after_subscribe(b)
        end
    end

    def update_subscriber
        if bildr = bildr_processe_is_ready(UPDATE_PROCESSE)
            processe_run = bildr.subscriber.subscribe

            bldr.subscriber.after_subscribe(b)
        end
    end

    def bildr_processe_is_ready(processe)
        bildr = Biller::Builder.new(processe)

        return unless bildr && obj.respond_to?(processe.downcase.to_sym)

        bildr
    end
end

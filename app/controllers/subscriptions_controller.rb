class SubscriptionsController < ApplicationController
    include CurrentBilly

    before_action :add_authkeys_for_api, only: [:entrance, :create]

    def entrance
        user_activator = UserActivationChecker.new

        return "/" if user_activator.completed?

        lookup_external_id_in_addons(params)

        render json: {
            subscriber: subscriber || {},
            mobavatar_activation: user_activator.verify_mobavatar(params)
        }
    end

    # subcriber to update the billing address
    def create
        render json: {subscriber: update_subscriber || {}}
    end

    private

    def subscriber
        l = lookup_billy_addon(params)

        if bil = bildr_processe_is_ready(SUBSCRIBER_PROCESSE)
            b = bil.subscriber.subscribe(l)

            bldr.subscriber.after_subscribe(b)
        end
    end

    def update_subscriber
        l = lookup_billy_addon(params)

        if bildr = bildr_processe_is_ready(SUBSCRIBER_PROCESSE)
            b = bildr.subscriber.update(l)

            bldr.subscriber.after_update(b)
        end
    end

    def bildr_processe_is_ready(processe)
        bildr = Biller::Builder.new(processe)

        return unless bildr && obj.respond_to?(processe.downcase.to_sym)

        bildr
    end
end

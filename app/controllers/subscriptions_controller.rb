class SubscriptionsController < ApplicationController
    include CurrentBilly

    SUBSCRIBER_PROCESSE = "Subscriber".freeze

    skip_before_filter :check_xhr

    before_action :add_authkeys_for_api, only: [:checker, :create]

    def entrance
    end

    def checker
        user_activator = UserActivationChecker.new(current_user)

        if user_activator.completed?
            puts "--------------- redirecting. ....."
            redirect_to "/"
        else
            addon = lookup_external_id_in_addons(params)

            if addon[:success]
                render json: {
                    subscriber: subscriber(addon) || {},
                    mobavatar_activation: user_activator.verify_mobavatar(params)
                }
            else
                render json: {
                    subscriber: addon.to_json,
                    mobavatar_activation: {}
                }
            end
        end
    end

    # subcriber to update the billing address
    def create
        render json: {subscriber: update_subscriber || {}}
    end

    private

    def subscriber(addon)
        if bdr = bildr_processe_is_ready(SUBSCRIBER_PROCESSE)
            if b = bdr.new.subscribe(addon || {})
                b.new.after_subscribe(b)
            end
        end
    end


    def update_subscriber
        l = lookup_external_id_in_addons(params)

        if bildr = bildr_processe_is_ready(SUBSCRIBER_PROCESSE)
            b = bildr.subscriber.update(l)
            bildr.subscriber.after_update(b)
        end
    end

    def bildr_processe_is_ready(processe)
        bildr = Biller::Builder.new(processe)

        return unless bildr.implementation

        bildr.implementation
    end
end

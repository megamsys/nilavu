class SubscriptionsController < ApplicationController
    include CurrentBilly

    SUBSCRIBER_PROCESSE = "Subscriber".freeze

    skip_before_filter :check_xhr

    before_action :add_authkeys_for_api, only: [:entrance, :create]

    def entrance
        user_activator = UserActivationChecker.new(current_user)
        puts "------- eNTERING"
        if user_activator.completed?
          puts "--------------- completed actiavtion"
            redirect_to "/"
        else
            puts "-------------- NOT"
            lookup_external_id_in_addons(params)
            puts "-------------- EXT"
            render json: {
                subscriber: subscriber || {},
                mobavatar_activation: user_activator.verify_mobavatar(params)
            }
        end
        puts "----------- eXITING"
    end

    # subcriber to update the billing address
    def create
        render json: {subscriber: update_subscriber || {}}
    end

    private

    def subscriber
        l = lookup_external_id_in_addons(params)

        if bdr = bildr_processe_is_ready(SUBSCRIBER_PROCESSE)
            b = bdr.new.subscribe(l || {})
            if  b && !b[:error]
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

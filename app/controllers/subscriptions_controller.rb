class SubscriptionsController < ApplicationController
    include CurrentBilly
    include LaunchableAssembler

    SUBSCRIBER_PROCESSE = "Subscriber".freeze

    skip_before_filter :check_xhr

    before_action :add_authkeys_for_api, only: [:checker, :create, :index, :add]


        def index
            render json: { regions: regions }
        end

    def entrance
    end

    def checker
      user_activator = UserActivationChecker.new(current_user)

      if user_activator.completed?
          redirect_to "/"
      else
          addon = lookup_external_id_in_addons(params)

          mob = user_activator.verify_mobavatar(params)

          render json: {
              subscriber: subscriber(addon[:addon]) || {},
              mobavatar_activation: mob.to_json
          }

      end

    end

    # subcriber to update the billing address
    def create
        addon = lookup_external_id_in_addons(params)
        a = addon[:addon].merge(params)
        if addon[:result] == "success"
          render json: {
              subscriber: update_subscriber(a) || {},
          }
        else
          render json: {
            subscriber: addon.to_json,
          }
        end
    end

    def add
        addon = lookup_external_id_in_addons(params)
        a = addon[:addon]
        if addon[:result] == "success"
          render json: {
              subscriber: update_subscriber(a) || {},
          }
        else
          render json: {
            subscriber: addon.to_json,
          }
        end
    end

    private

    def subscriber(addon)
        if bdr = bildr_processe_is_ready(SUBSCRIBER_PROCESSE)
            b = bdr.new.subscribe(addon || {})
            bdr.new.after_subscribe(b)
        else
          something_wrong
        end
    end


    def update_subscriber(addon)
        if bildr = bildr_processe_is_ready(SUBSCRIBER_PROCESSE)
          b = bildr.new.update(addon || {})
          bildr.new.after_update(b)
        else
          something_wrong
        end
    end

    def bildr_processe_is_ready(processe)
        bildr = Biller::Builder.new(processe)

        return unless bildr.implementation

        bildr.implementation
    end

    def something_wrong
        {:result => "error", :error => "user.activation.unknown"}
    end

end

class SubscriptionsController < ApplicationController

    before_action :add_authkeys_for_api, only: [:entrance, :show, :create]

    def entrance
        return "/" if activation_completed?

        activating_mobavatar

        render json: {subscriber_details: subscriber_details}
    end

    # subcriber to update the billing address
    def create
    end

    private

    def activation_completed?
        return true unless SiteSetting.allow_default_billings
        puts "--- activation_flag"
        puts activation_flag?.inspect
        puts "----"
        return activation_flag?
    end

    def activation_flag?
        current_user.approved || current_user.active
    end


    def activating_mobavatar
        return Nilavu::NotFound unless current_user.phone

        MobileAvatarActivator.new({phone: current_user.phone}).start
    end

    def subscriber_details
      return {}
    end
end

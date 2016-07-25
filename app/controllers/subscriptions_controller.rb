class SubscriptionsController < ApplicationController

    before_action :add_authkeys_for_api, only: [:entrance, :show, :create]

    def entrance
        return "/" if activation_completed?

        activating_mobavatar

        render json: {subs: savedsubs} 
    end

    def show
        render json: {subs: savedsubs}
    end


    def create
        Api::Subscriptions.new.create(params)
    end

    private

    def savedsubs
        Api::Subscriptions.new.show(params)
    end

    def activating_mobavatar
        return Nilavu::NotFound unless current_user.phone

        MobileAvatarActivator.new({phone: current_user.phone}).start
    end

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

end

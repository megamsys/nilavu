class SubscriptionsController < ApplicationController
    include BillyUser

    before_action :add_authkeys_for_api, only: [:entrance, :show, :create]

    def entrance
        return "/" if activation_completed?

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

        user.email_confirmed? ? login(user) : not_activated(user)

        activating_billy_user

        render json: {subscriber: subscriber}
    end

    # subcriber to update the billing address
    def create
    end

    private

    def invalid_credentials
      render json: {error: I18n.t("login.not_onboarded_in_billy")}
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

    def registered_billy
      return {}
    end


    def activating_billy_user
        return Nilavu::NotFound unless current_user.phone

        MobileAvatarActivator.new({phone: current_user.phone}).start
    end

    def subscriber
        return {}
    end

    def not_found
      return
    end
end

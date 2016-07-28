class MobileAvatarActivator
    attr_reader :user, :params

    def initialize(user, params)
        @user = user
        @params = params
    end

    def start
        activator.activating
    end

    def finish
        activator.activate
    end

    private

    def activator
        factory.new(user)
    end

    def factory
        return OTPActivator if !current_user.phone_verified

        NoOP
    end

    def phone_params
        params.merge!({phone: user.phone})
    end

end


class OTPActivator < BillyActivator

    def activating
        identity = MobileAvatar::Identity.new.from_number(phone_params)
        result = identity.generate
        return I18n.t("login.activating_phone_error") unless result

        result.succeeded? ? I18n.t("login.activating_phone", user.phone) : I18n.t("login.not_activating_phone")
    end

    def activate
        identity = MobileAvatar::Identity.new.from_number(phone_params)
        result = identity.verify
        return I18n.t("login.activate_phone_error") unless result

        result.correct_pin? ? I18n.t("login.activate_phone", user.phone) :  I18n.t("login.not_activated_phone")
    end
end

class NOOP < BillyActivator
    def activating
        return I18n.t("login.already_activated_phone", user.phone)
    end
    def activate
        return I18n.t("login.already_activated_phone", user.phone)
    end
end

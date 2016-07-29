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

    def dont_force?
        !params.include?(:force)
    end


    def factory
        return OTPActivator unless (user.phone_verified  || dont_force?) && SiteSetting.allow_mobavatar_verifications

        NOOPActivator
    end

    def phone_params
        params.merge!({phone: user.phone})
    end

end


class OTPActivator < MobileAvatarActivator

    def activating
        identity = MobileAvatar::Identity.new.from_number(phone_params)
        result = MobileAvatar.generate(identity: identity)
        return I18n.t("login.activating_phone_error") unless result

        result.succeeded? ? I18n.t("login.activating_phone", phone: user.phone) : I18n.t("login.not_activating_phone")
    end

    def activate
        identity = MobileAvatar::Identity.new.from_number(phone_params)
        result = identity.verify(identity: identity)
        return I18n.t("login.activate_phone_error") unless result

        result.correct_pin? ? I18n.t("login.activate_phone", phone: user.phone) :  I18n.t("login.not_activated_phone")
    end
end

class NOOPActivator < MobileAvatarActivator
    def activating
        ## Show these messages for testing only. I don't think we need it in prod.
        return I18n.t("login.skipped_activating_phone", phone: user.phone)
    end
    def activate
        ## Show these messages for testing only. I don't think we need it in prod.
        return I18n.t("login.skipped_activate_phone", phone: user.phone)
    end
end

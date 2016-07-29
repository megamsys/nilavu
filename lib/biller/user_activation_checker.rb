require 'current_user'

class UserActivationChecker
    include CurrentUser

    def completed?
        not_required?  ? true : send_current_status
    end

    def not_required?
        return true unless SiteSetting.allow_billings
    end

    def send_current_status
        current_user.approved || current_user.active
    end


    def verify_mobavatar(params)
        return Nilavu::NotFound unless current_user.phone

        MobileAvatarActivator.new(current_user, params).start
    end
end

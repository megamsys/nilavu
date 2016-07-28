class UserActivationChecker

    def check_activation_completed?
        return true unless SiteSetting.allow_default_billings || current_user.approved || current_user.active

        puts "--- activation_status"
        puts activation_status?.inspect
        puts "----"
        return activation_status?
    end

    def activation_flag?
        current_user.approved || current_user.active
    end


    def activating_mobile_avatar
        return Nilavu::NotFound unless current_user.phone

        MobileAvatarActivator.new(current_user, params).start
    end
end

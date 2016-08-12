require 'current_user'

class UserActivationChecker

    attr_reader :current_user

    def initialize(user)
      @current_user = user
    end

    def completed?
        puts "--NOT ---- #{not_required?}"
        puts "--NOT1---- #{send_current_status}"
        not_required?  ? true : send_current_status
    end

    def not_required?
        return true unless SiteSetting.allow_billings
    end

    def send_current_status
        puts "--- SEND CURR  #{@current_user.approved} #{@current_user.approved.present?}"
        puts "--- SEND CURR1 #{@current_user.active} #{@current_user.active.present?}"
        @current_user.approved || @current_user.active
    end


    def verify_mobavatar(params)
        return Nilavu::NotFound unless @current_user.phone

        MobileAvatarActivator.new(@current_user, params).start
    end
end

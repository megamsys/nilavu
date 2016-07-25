class MobileAvatarActivator
    attr_reader :user, :message

    def initialize(user)
        @user = user
        @message = nil
    end

    def start
      @message = activator.activating
    end

    def finish
      @message = activator.activate
    end

    private

    def activator
        factory.new(user)
    end

    def factory
        if !user.active?
            OTPActivator
        end
    end

end


class OTPActivator < MobileAvatarActivator

    def activating
        identity = MobileAvatar::Identity.new.from_number(params)
        identity.generate
        #if result.succeeded? ||  result.error
    end

    def activate
        identity = MobileAvatar::Identity.new.from_number(params)
        identity.verify
        #return if result.correct_pin?
    end

end

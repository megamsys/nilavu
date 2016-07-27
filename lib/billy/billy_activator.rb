class BillyActivator
    attr_reader :billy, :message

    def initialize(user)
        @user = user
        @message = nil
    end

    def start
      @message = activators.map{|activator| activator.activating}
    end

    def finish
      @message = activators.map{|activator|  activator.activate}
    end

    private

    def activators
        factorys.map{|factory| factory.new(user)}
    end

    def factorys
        if !user.active?
            [OTPActivator, BillysActivator]
        end
    end

end


class OTPActivator < BillyActivator

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

class LogonBillysActivator < BillyActivator
    include CurrentBilly

    def activating
      log_on_billy(billy)
    end

    def activate
    end
end

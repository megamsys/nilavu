class MobileAvatar

    class Identity
        attr_accessor :number, :pin, :otp

        def self.from_number(params)
            identity = new
            [:number, :pin, :otp].each do |setting|
                identity.send("#{setting}=", params[setting])
            end

            identity
        end
    end


    class << self

        def bipping_number(identity)
            Infobip.send_pin_to(identity.number)
        end

        def bipped_number(identity)
            Infobip.verify_pin(identity.otp, identity.pin, identity.number)
        end

        def generate(opts = nil)
            identity = opts && opts[:identity]

            bipping = bipping_number(identity)

            #if result.succeeded? ||  result.error

            #end
            bipping
        end

        def verify(identity)

            identity = opts && opts[:identity]

            bipped = bipped_number(identity)

            #return if result.correct_pin?
            bipped
        end
    end
end

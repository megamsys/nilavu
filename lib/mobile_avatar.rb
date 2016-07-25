class MobileAvatar

    class Identity
        attr_accessor :phone, :pin, :otp

        def self.from_number(params)
            identity = new
            [:phone, :pin, :otp].each do |setting|
                identity.send("#{setting}=", params[setting])
            end

            identity
        end
    end


    class << self

        def bipping_number(identity)
            Infobip.send_pin_to(identity.phone)
        end

        def bipped_number(identity)
            Infobip.verify_pin(identity.otp, identity.pin, identity.phone)
        end

        def generate(opts = nil)
            identity = opts && opts[:identity]

            bipping = bipping_number(identity)

            bipping
        end

        def verify(identity)

            identity = opts && opts[:identity]

            bipped = bipped_number(identity)

            bipped
        end
    end
end

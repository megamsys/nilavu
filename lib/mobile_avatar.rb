class MobileAvatar

    class Identity
        attr_accessor :phone, :pin, :otp

        def self.from_number(params)
          puts "******************************************************************************************************from_number"

            identity = new
            [:phone, :pin, :otp].each do |setting|
                identity.send("#{setting}=", params[setting])
            end

            identity
        end
    end


    class << self

        def bipping_number(identity)
          puts "******************************************************************************************************from_number_ afterbipping_number"
          puts Infobip.send_pin_to(identity.phone).inspect
          puts "******************************************************************************************************from_number_ afterbipping_number"
          
            Infobip.send_pin_to(identity.phone)
        end

        def bipped_number(identity)
            Infobip.verify_pin(identity.otp, identity.pin, identity.phone)
        end

        def generate(opts = nil)
            identity = opts && opts[:identity]
            return Nilavu::NotFound unless identity

            bipping_number(identity)
        end

        def verify(opts = nil)
          puts "****************************************************************************************************phone"
            identity = opts && opts[:identity]
            return Nilavu::NotFound unless identity

            bipped_number(identity)
        end
    end
end

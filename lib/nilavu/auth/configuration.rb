module Nilavu
  module Auth
    class Configuration
      attr_accessor :email, :password, :api_key, :first_name, :last_name, :authority, :verified, :password_reset_key, :password_reset_sent_at

      BUCKET              = 'accounts'.freeze
      ADMIN               = 'admin'.freeze

      def initialize(parms ={})
        email parms[:email]
        password parms[:password]
        api_key parms[:api_key]
        first_name parms[:first_name]
        last_name parms[:last_name]
        password parms[:phone]
        authority parms[:authority]
        verified parms[:verified]
        password_reset_key parms[:password_reset_key]
        password_reset_sent_at parms[:password_reset_sent_at]
        created_at parms[:created_at]
      end

      def self.load(email)
        riak = Nilavu::DB::GSRiak.new(BUCKET).fetch(email)
        unless riak.content.data.nil?
          return self.from_hash(riak.content.data)
        end
      end

      def email(arg=nil)
        if arg != nil
          @email = arg
        else
          @email
        end
      end

      def api_key(arg=nil)
        if arg != nil
          @api_key = arg
        else
          @api_key
        end
      end

      def first_name(arg=nil)
        if arg != nil
          @first_name = arg
        else
          @first_name
        end
      end

      def last_name(arg=nil)
        if arg != nil
          @last_name = arg
        else
          @last_name
        end
      end

      def password(arg=nil)
        if arg != nil
          @password = arg
        else
          @password
        end
      end

      def phone(arg=nil)
        if arg != nil
          @phone = arg
        else
          @phone
        end
      end

      def authority(arg=nil)
        if arg != nil
          @authority = arg
        else
          @authority
        end
      end

      def verified(arg=nil)
        if arg != nil
          @verified = arg
        else
          @verified
        end
      end

      def password_reset_key(arg=nil)
        if arg != nil
          @password_reset_key = arg
        else
          @password_reset_key
        end
      end

      def password_reset_sent_at(arg=nil)
        if arg != nil
          @password_reset_sent_at = arg
        else
          @password_reset_sent_at
        end
      end

      def created_at(arg=nil)
        if arg != nil
          @created_at = arg
        else
          @created_at
        end
      end

      def to_hash
        { :email => @email,
          :api_key => @api_key,
          :password => SignVerifier.encrypt(@password),
          :first_name => @first_name,
          :last_name => @last_name,
          :phone => @phone,
          :authority => ADMIN,
          :password_reset_key => @password_reset_key,
          :password_reset_sent_at => @password_reset_sent_at,
        :created_at => @created_at, :verified => @verified }
      end

      def  self.from_hash(hld_hash)
        Configuration.new(Hash[hld_hash.map{|(k,v)| [k.to_sym,v]}])
      end
    end
  end
end

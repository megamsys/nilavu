require "base64"
module Nilavu
  module Auth
    class SignVerifier
      class PasswordMissmatchFailure < StandardError; end
      class InvalidPasswordFailure < StandardError; end

      ## SignatureVerifier delegate (Forwardable)
      def authenticate(auth_config, entered_password)
        unless decrypt(auth_config.password) == entered_password
          fail PasswordMissmatchFailure, 'Au oh!, The email or password you entered is incorrect.'
        end
      end

      def self.encrypt(password)
        Base64.strict_encode64(password)
      end

      def self.hmackey
        p SecureRandom.urlsafe_base64(nil, true)
      end

      private
      def decrypt(password)
      @password =  Base64.strict_decode64(password)
      end
    end
  end
end

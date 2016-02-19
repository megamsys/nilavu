require "base64"
require "bcrypt"
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
         BCrypt::Password.create(password)
        #Base64.encode64(password)
      end

      def self.hmackey
        p SecureRandom.urlsafe_base64(nil, true)
      end

      private
      def decrypt(password)
      #   Base64.decode64(password)
      @password =   BCrypt::Password.create(password)
        BCrypt::Password.new(password)
        rescue BCrypt::Errors::InvalidHash
       raise InvalidPasswordFailure, 'Au oh!, The password you entered is incorrect.'
      end
    end
  end
end

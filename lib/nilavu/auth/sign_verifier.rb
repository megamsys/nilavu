require 'bcrypt'
module Nilavu
  module Auth
    class SignVerifier
      class PasswordMissmatchFailure < StandardError; end
      class InvalidPasswordFailure < StandardError; end

      ## SignatureVerifier delegate (Forwardable)
      def authenticate(password, &_block)
        unless decrypt(password) == params[:password]
          fail PasswordMissmatchFailure, 'Au oh!, The email or password you entered is incorrect.'
        end
        yield tmp if block_given?
        tmp
      end

      def encrypt(password)
        BCrypt::Password.create(password)
      end

      def hmackey
        p SecureRandom.urlsafe_base64(nil, true)
      end

      private
      def decrypt(password)
        BCrypt::Password.new(password)
      rescue BCrypt::Errors::InvalidHash
        raise InvalidPasswordFailure, 'Au oh!, The password you entered is incorrect.'
      end
    end
  end
end

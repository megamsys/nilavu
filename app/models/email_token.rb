class EmailToken
  attr_accessor :user

  attr_accessor :token

  def self.token_length
    16
  end

  def self.generate_token
    SecureRandom.hex(EmailToken.token_length)
  end

  def self.valid_token_format?(token)
    #return token.present? && token =~ /[a-f0-9]{#{token.length/2}}/i
    return true
  end

  def self.confirmable(token)
    @token = token

    return self if confirm_email(token)
  end

  private

  def confirm_email(token)
    user = Api::EmailToken.new.where(parms_using_password)
    if user
      @user = User.new_from_params(user.to_hash)
    end
  end
end

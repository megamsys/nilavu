class UserUpdater

  OPTION_ATTR = [
    :first_name,
    :last_name,
    :password,
    :verified,
    :status,
    :password_reset_key,
    :password_reset_sent_at
  ]

  def initialize(user)  
    @user = user
  end

  def update(attributes = {})   
    @user.email = attributes.fetch(:email) { @user.email }
    @user.password = attributes.fetch(:password) { @user.password }
    @user.api_key = attributes.fetch(:api_key) { @user.api_key }     
    OPTION_ATTR.each do |attribute|
      if attributes.key?(attribute)       
        user.send("#{attribute}=", attributes[attribute])
      end
    end

    user.update
  end

  private

  attr_reader :user

end

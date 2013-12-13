module UsersHelper
  
  def generate_api_token
    p SecureRandom.urlsafe_base64(nil, true)
  end
   
end

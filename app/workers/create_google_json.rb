class CreateGoogleJSON
  
  def self.perform(token, r_token, expire, p_name, id, s_key)    
    gsj = File.new(ENV['HOME']+"/.google-compute.json", "w")
    json = to_hash(token, r_token, expire, p_name, id, s_key).to_json
    gsj.puts(json)
    gsj.close
  end
  
  def self.to_hash(access_token, refresh_token, expire, project_name, id, secret_key)
      g_hash = Hash.new
      g_hash["authorization_uri"] = Rails.configuration.authorization_uri
      g_hash["token_credential_uri"] = Rails.configuration.token_credential_uri
      g_hash["scope"] = Rails.configuration.scope
      g_hash["redirect_uri"] = Rails.configuration.redirect_uri
      g_hash["client_id"] = id
      g_hash["client_secret"] = secret_key
      g_hash["access_token"] = access_token
      g_hash["expires_in"] = expire
      g_hash["refresh_token"] = refresh_token
      g_hash["project"] = project_name        
      g_hash
    end
  
end

   
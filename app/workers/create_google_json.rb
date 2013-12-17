# This can be a private method in the controller.
# we don't need a worker.
#
class CreateGoogleJSON
  def self.perform(token, r_token, expire, p_name, id, s_key)
    #TO-DO:this has a static reference to ENV['HOME'] - may not work on prod. eg: if the server runs on
    #podnix cloud @ let us say ip 202.155.909.99, How will the file exist there ?
    #Also even if the file exists there, when multiple users try to setup google cloud the file
    #will get overwritten.
    #I think this is just tied to a localhost implementation, we need to revisit the workings.
    gsj = File.new(ENV['HOME']+"/.google-compute.json", "w")
    json = to_hash(token, r_token, expire, p_name, id, s_key).to_json
    json
  end

  def self.to_hash(access_token, refresh_token, expire, project_name, id, secret_key)
    g_hash = Hash.new
    g_hash[:authorization_uri] = Rails.configuration.google_authorization_uri
    g_hash[:token_credential_uri] = Rails.configuration.google_token_credential_uri
    g_hash[:scope] = Rails.configuration.google_scope
    g_hash[:redirect_uri] = Rails.configuration.google_redirect_uri
    g_hash[:client_id] = id
    g_hash[:client_secret] = secret_key
    g_hash[:access_token] = access_token
    g_hash[:expires_in] = expire
    g_hash[:refresh_token] = refresh_token
    g_hash[:project] = project_name
    g_hash
  end

end


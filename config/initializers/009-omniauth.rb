require "openssl"

# if you need to test this and are having ssl issues see:
#  http://stackoverflow.com/questions/6756460/openssl-error-using-omniauth-specified-ssl-path-but-didnt-work
#  provider :facebook, Ind.oauth.facebook.client_id, Ind.oauth.facebook.secret_key,:scope => "email", :display => 'popup'
#  provider :github, Ind.oauth.github.client_id,Ind.oauth.github.secret_key,:scope => "user:email, #repo:email, admin:repo_hook"
#  provider :google_oauth2, Ind.oauth.google.client_id, Ind.oauth.google.secret_key , { :scope => #"userinfo.profile, userinfo.email, devstorage.full_control, compute", :prompt => 'consent'}

Rails.application.config.middleware.use OmniAuth::Builder do
  #Nilavu.authenticators.each do |authenticator|
  #  authenticator.register_middleware(self)
  #end
end

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, Ind.oauth.facebook.client_id,  Ind.oauth.facebook.secret_key,:scope => "email, public_profile"
  provider :github, Ind.oauth.github.client_id,Ind.oauth.github.secret_key,:scope => "user:email, public_repo, repo, repo:status, notification"
  provider :google_oauth2, Ind.oauth.google.client_id, Ind.oauth.google.secret_key , { :scope => "userinfo.profile, userinfo.email, devstorage.full_control, compute", :prompt => 'consent'}
end

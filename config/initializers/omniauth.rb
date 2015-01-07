Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, Rails.configuration.fb_client_id,  Rails.configuration.fb_secret_key,:scope => "email, public_profile"
  provider :github, Rails.configuration.github_client_id,Rails.configuration.github_secret_key,:scope => "user:email, public_repo, repo, repo:status, notification"
  provider :google_oauth2, Rails.configuration.google_client_id, Rails.configuration.google_secret_key , { :scope => "userinfo.profile, userinfo.email, devstorage.full_control, compute", :prompt => 'consent'}
  provider :assembla, Rails.configuration.assembla_client_id, Rails.configuration.assembla_secret_key
end

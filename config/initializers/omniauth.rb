Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, Rails.configuration.fb_client_id, Rails.configuration.fb_secret_key
  provider :twitter, Rails.configuration.twitter_client_id, Rails.configuration.twitter_secret_key
  #Riak_change
  #Is these keys needed for private megam?
  provider :github, ENV['GITHUB_KEY'], ENV['GITHUB_SECRET'], :scope => "user:email, public_repo, repo, repo:status, notification"

  provider :google_oauth2, ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_SECRET_KEY'], {  
      :scope => "userinfo.profile, userinfo.email, devstorage.full_control, compute",
      :prompt => 'consent'     
    }
  provider :assembla, ENV['ASSEMBLA_APP_ID'], ENV['ASSEMBLA_APP_SECRET']
end

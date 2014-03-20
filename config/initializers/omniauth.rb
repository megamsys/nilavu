Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV['FACEBOOK_CLIENT_ID'], ENV['FACEBOOK_SECRET_KEY']
  provider :twitter, ENV['TWITTER_CLIENT_ID'], ENV['TWITTER_SECRET_KEY']
  provider :github, ENV['GITHUB_KEY'], ENV['GITHUB_SECRET'], :scope => "user:email, public_repo, repo, repo:status, notification"
  provider :google_oauth2, ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_SECRET_KEY'], {  
      :scope => "userinfo.profile, userinfo.email, devstorage.full_control, compute",
      :prompt => 'consent'     
    }
end

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV['FACEBOOK_CLIENT_ID'], ENV['FACEBOOK_SECRET_KEY']
  provider :twitter, ENV['TWITTER_CLIENT_ID'], ENV['TWITTER_SECRET_KEY']
  provider :github, ENV['GITHUB_KEY'], ENV['GITHUB_SECRET'], :scope => "user:email, public_repo, repo, repo:status, notification"
  provider :google_oauth2, ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_SECRET_ID'], {
      :scope => "userinfo.email, userinfo.profile, https://www.googleapis.com/auth/compute, https://www.googleapis.com/auth/compute.readonly, https://www.googleapis.com/auth/devstorage.full_control, https://www.googleapis.com/auth/devstorage.read_only, https://www.googleapis.com/auth/devstorage.read_write, https://www.googleapis.com/auth/devstorage.write_only, https://www.googleapis.com/auth/userinfo.email",
      :prompt => 'consent'
    }
end

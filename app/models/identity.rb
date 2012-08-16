class Identity < ActiveRecord::Base
  belongs_to :user
  validates :provider, :uid, :presence => true
  def self.find_from_omniauth(auth)
    find_by_provider_and_uid(auth['provider'], auth['uid'])
  end

  def self.create_from_omniauth(auth, user = nil)
    user ||= User.create_from_auth_hash!(auth)
    user.save(:validate => false)
    self.create(:user => user, :uid => auth['uid'], :provider => auth['provider'])
  end

end

class Identity < ActiveRecord::Base
attr_accessible :users_id, :uid, :provider
  belongs_to :user, :foreign_key  => 'users_id'
  validates :provider, :uid, :presence => true
  def self.find_from_omniauth(auth)
    find_by_provider_and_uid(auth['provider'], auth['uid'])
  end

  def self.create_from_omniauth(auth, user = nil)
    self.create(:uid => auth['uid'], :provider => auth['provider'])
  end

end

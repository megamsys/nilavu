class Identity < ActiveRecord::Base

attr_accessible :users_id, :uid, :provider

  belongs_to :user
  validates :provider, :uid, :presence => true
  def self.find_from_omniauth(auth)
    find_by_provider_and_uid(auth['provider'], auth['uid'])
  end

  def self.create_from_omniauth(auth, user = nil)
puts "AUTH ===>  "
puts auth
    user ||= User.create_from_auth_hash!(auth)
puts "USER ===> "
puts user.email
@user = User.new(:email => user.email)
    @user.save

    self.create(:users_id => @user.id, :uid => auth['uid'], :provider => auth['provider'])
  end

end

class User < ActiveRecord::Base
  # users.password_hash in the database is a :string
  attr_accessible :first_name, :last_name, :admin, :phone, :onboarded_api, :user_type, :email, :api_token, :password, :password_confirmation, :verified_email, :verification_hash, :app_attributes, :cloud_identity_attributes, :apps_item_attributes
  has_secure_password
  
  has_many :identities, :foreign_key => 'users_id'
  accepts_nested_attributes_for :identities, :update_only => true 

  has_many :dashboards, :foreign_key  => 'user_id'
  accepts_nested_attributes_for :dashboards, :update_only => true
 

  before_save { |user| user.email = email.downcase }

  #validates_existence_of :email

  validates :email, :presence => true, :uniqueness => true

  def self.create_from_auth_hash!(auth_hash)
    create(:first_name => auth_hash["info"]["name"], :last_name => auth_hash["info"]["last_name"],
    :email => auth_hash["info"]["email"], :phone => auth_hash["info"]["phone"], :admin => true)
  end


before_create { generate_token(:remember_token) }

def send_password_reset
  generate_token(:password_reset_token)
  self.password_reset_sent_at = Time.zone.now
  save!
  UserMailer.password_reset(self).deliver
end

def generate_token(column)
  begin
    self[column] = SecureRandom.urlsafe_base64
  end while User.exists?(column => self[column])
end

end


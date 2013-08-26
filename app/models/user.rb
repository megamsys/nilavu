class User < ActiveRecord::Base
  # users.password_hash in the database is a :string
  attr_accessible :first_name, :last_name, :admin, :phone, :onboarded_api, :user_type, :email, :api_token, :password, :password_confirmation, :verified_email, :verification_hash, :org_id, :cloud_book_attributes, :organization_attributes, :cloud_identity_attributes, :apps_item_attributes
  has_secure_password
  
  has_many :identities, :foreign_key => 'users_id'
  accepts_nested_attributes_for :identities, :update_only => true 

  belongs_to :organization, :foreign_key => 'org_id'
  accepts_nested_attributes_for :organization, :update_only => true

  has_many :cloud_identities, :foreign_key => 'users_id'
  accepts_nested_attributes_for :cloud_identities, :update_only => true

  has_many :apps_items, :foreign_key => 'users_id'
  accepts_nested_attributes_for :apps_items, :update_only => true

  has_many :cloud_books, :foreign_key  => 'users_id'
  accepts_nested_attributes_for :cloud_books, :update_only => true
 

  before_save { |user| user.email = email.downcase }
  before_save :create_remember_token

  #validates_existence_of :email

  validates :email, :presence => true, :uniqueness => true

  def self.create_from_auth_hash!(auth_hash)
    create(:first_name => auth_hash["info"]["name"], :last_name => auth_hash["info"]["last_name"],
    :email => auth_hash["info"]["email"], :phone => auth_hash["info"]["phone"], :admin => true)
  end

  private

  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end

end


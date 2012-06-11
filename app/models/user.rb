class User < ActiveRecord::Base
  # users.password_hash in the database is a :string
  has_many :identities
  attr_accessor :password, :id
  before_save :encrypt_password

  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates_presence_of :email
  validates_presence_of :name
  validates_uniqueness_of :email
  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end

  
  def self.authenticate(email, password)
    logger.debug "email is #{email} password #{password}"
    
    user = find_by_email(email)
    logger.debug user.inspect
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
    user
    else
      nil
    end
  end

  def self.create_from_auth_hash!(auth_hash)
    create(:name => auth_hash["info"]["name"], :email => auth_hash["info"]["email"])
  end

end

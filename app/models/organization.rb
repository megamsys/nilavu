class Organization < ActiveRecord::Base
  attr_accessible :active, :billing_address1, :billing_address2, :billing_city, :billing_country, :billing_state, :billing_street_name, :name, :account_name, :type, :url, :logo
  has_attached_file :logo
  has_many :users
  has_one :cloud_identity
  #accepts_nested_attributes_for :cloud_identity

  validates_attachment_presence :logo
  validates_attachment_size :logo, :less_than => 5.megabytes
  validates_attachment_content_type :logo, :content_type => ['image/jpeg', 'image/png', 'image/gif']

end

class Organization < ActiveRecord::Base
  attr_accessible :active, :billing_address1, :billing_address2, :billing_city, :billing_country, :billing_state, :billing_street_name, :name, :realm_name, :type, :url
  has_attached_file :logo
  validates_attachment_presence :photo
  validates_attachment_size :photo, :less_than => 5.megabytes
  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png', 'image/gif']
  has_many :users
  accepts_nested_attributes_for :users
end

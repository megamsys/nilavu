class Organization < ActiveRecord::Base
  attr_accessible :active, :billing_address1, :billing_address2, :billing_city, :billing_country, :billing_state, :billing_street_name, :name, :url, :logo
	has_attached_file :logo,

    :storage => :s3,
    :s3_permissions => :public_read,
    :s3_credentials => "config/aws.yml",
    :s3_host_name => "s3-ap-southeast-1.amazonaws.com",
    :path => "dino/:id/:filename"

  

  has_many :users



  validates_attachment_presence :logo
  validates_attachment_size :logo, :less_than => 5.megabytes
  validates_attachment_content_type :logo, :content_type => ['image/jpeg', 'image/png', 'image/gif']

end

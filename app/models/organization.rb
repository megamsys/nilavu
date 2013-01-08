class Organization < ActiveRecord::Base
  attr_accessible :active, :billing_address1, :billing_address2, :billing_city, :billing_country, :billing_state, :billing_street_name, :name, :account_name, :url, :logo, :api_token, :cloud_identity_attributes, :apps_item_attributes
  has_attached_file :logo,

    :storage => :s3,
    :s3_permissions => :public_read,
    :s3_credentials => "config/aws.yml",
    :s3_host_name => "s3-ap-southeast-1.amazonaws.com",
    :path => "dino/:id/:filename"

  validate :acc_name
  
  def acc_name
    @name = self.name.gsub(/[^0-9A-Za-z]/, '')
    @name = @name.gsub(" ", "")
    if @name.length > 10
    self.account_name = @name.slice(0,10)
    else
    self.account_name = @name
    end
  end

  has_many :users

  has_one :cloud_identity, :foreign_key  => 'org_id'
  accepts_nested_attributes_for :cloud_identity, :update_only => true

  has_many :apps_items, :foreign_key  => 'org_id'
  accepts_nested_attributes_for :apps_items, :update_only => true

  validates_attachment_presence :logo
  validates_attachment_size :logo, :less_than => 5.megabytes
  validates_attachment_content_type :logo, :content_type => ['image/jpeg', 'image/png', 'image/gif']

end

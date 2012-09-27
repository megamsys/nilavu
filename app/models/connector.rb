class Connector < ActiveRecord::Base
  attr_accessible :salesforce_consumer_key, :salesforce_consumer_secret, :cloud_app_id

  belongs_to :cloud_app, :foreign_key  => 'cloud_app_id'
end

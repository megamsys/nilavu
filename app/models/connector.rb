class Connector < ActiveRecord::Base
  attr_accessible :salesforce_consumer_key, :salesforce_consumer_secret, :cloud_app_id, :description, :connector_action_attributes, :connector_output_attributes

  belongs_to :cloud_app, :foreign_key  => 'cloud_app_id'
  has_many :connector_actions, :foreign_key  => 'connector_id'
  has_many :connector_outputs, :foreign_key  => 'connector_id'

	accepts_nested_attributes_for :connector_actions, :update_only => true
	accepts_nested_attributes_for :connector_outputs, :update_only => true

end

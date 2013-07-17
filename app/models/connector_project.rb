class ConnectorProject
=begin  
  include Dynamoid::Document

  field :description
  field :consumer_key
  field :consumer_secret
  field :access_username
  field :access_password
  field :provider
  field :category
  field :user_email
  field :org_name

  has_many :connector_executions
  has_many :connector_actions
  has_many :connector_outputs
=end 
end

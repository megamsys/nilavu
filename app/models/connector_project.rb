class ConnectorProject
  include Dynamoid::Document

  #table :name => :ConnectorProject, :key => :Id, :read_capacity => 10, :write_capacity => 10


  field :description
  field :consumer_key
  field :consumer_secret
  field :access_username
  field :access_password
  field :provider
  field :category
  field :description
  field :user_email
  field :org_name

 # index :created_at, :range => true
 # attr_accessible :connector_action_attributes, :connector_output_attributes
  
  #accepts_nested_attributes_for :connector_output, :update_only => true

  has_many :connector_actions
  has_many :connector_outputs
  #accepts_nested_attributes_for :connector_action, :update_only => true
end

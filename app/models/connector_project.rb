class ConnectorProject
  include Dynamoid::Document

  #table :name => :ConnectorProject, :key => :Id, :read_capacity => 10, :write_capacity => 10


  field :Name
  field :Description
  field :Status
  field :Category
  field :Provider
  field :Consumer_Key
  field :Consumer_Secret

 # index :created_at, :range => true
 # attr_accessible :connector_action_attributes, :connector_output_attributes
  
  #accepts_nested_attributes_for :connector_output, :update_only => true

  has_many :connector_actions
  has_many :connector_outputs
  #accepts_nested_attributes_for :connector_action, :update_only => true
end

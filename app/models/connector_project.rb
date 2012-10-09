class ConnectorProject
  include Dynamoid::Document

  table :name => :ConnectorProject, :key => :Id, :read_capacity => 10, :write_capacity => 10


  field :Name
  field :Description
  field :Status
  field :Category
  field :Provider
  field :Consumer_Key
  field :Consumer_Secret

 # index :created_at, :range => true

  has_many :ConnectorActions
  has_many :ConnectorOutputs
  
end


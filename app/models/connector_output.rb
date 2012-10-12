class ConnectorOutput
  include Dynamoid::Document

  #table :name => :ConnectorOutput, :key => :Id, :read_capacity => 10, :write_capacity => 10


  field :Project_Id
  field :Type
  field :Location

	belongs_to :connector_project
end


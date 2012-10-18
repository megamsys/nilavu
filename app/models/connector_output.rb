class ConnectorOutput
  include Dynamoid::Document

  field :type
  field :location

	belongs_to :connector_project
end


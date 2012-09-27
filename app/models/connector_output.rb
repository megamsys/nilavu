class ConnectorOutput < ActiveRecord::Base
  attr_accessible :log, :message, :output_display, :status, :connector_id
  belongs_to :connector, :foreign_key  => 'connector_id'
end

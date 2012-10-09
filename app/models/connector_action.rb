class ConnectorAction
  include Dynamoid::Document

  table :name => :ConnectorAction, :key => :Id, :read_capacity => 10, :write_capacity => 10


  field :Project_Id
  field :Name
  field :Email
  field :UserNAme
  field :Locale
    
  index :Name, :range => true

	belongs_to :ConnectorProject
end


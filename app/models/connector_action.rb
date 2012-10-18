class ConnectorAction
  include Dynamoid::Document

  #table :name => :ConnectorAction, :key => :Id, :read_capacity => 10, :write_capacity => 10

  field :biz_function
  field :alias
  field :email
  field :charset_encoding
  field :language
  field :last_name
  field :locale
  field :profile
  field :time_zone

  #range :biz_function, :string
    
  #index :Name, :range => true

	belongs_to :connector_project
end


class ConnectorAction
  include Dynamoid::Document

  field :biz_function
  field :alias
  field :email
  field :charset_encoding
  field :language
  field :last_name
  field :locale
  field :profile
  field :time_zone

  belongs_to :connector_project

end


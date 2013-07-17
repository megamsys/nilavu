class ConnectorExecution
=begin  
  include Dynamoid::Document
  
  
  field :access_email
  field :access_org_id
  field :access_account_name
  field :api_token
  field :result
 


  belongs_to :connector_project
=end
end

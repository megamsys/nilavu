class ConnectorAction < ActiveRecord::Base
  	 attr_accessible :user_name, :profile_id, :first_name, :last_name, :email, :alias, :time_zone, :locale, :char_set_encoding, :language, :connector_id

   belongs_to :connector, :foreign_key  => 'connector_id'
end

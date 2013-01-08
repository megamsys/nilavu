class CloudRun < ActiveRecord::Base
  attr_accessible :description, :launch_time, :log, :name, :status, :users_id

  belongs_to :user
end

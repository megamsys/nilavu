class Widget < ActiveRecord::Base
   belongs_to :dashboard

  serialize :settings

  validates :name, :kind, :source, :dashboard_id, :presence => true

  attr_accessible :name, :kind, :source, :size, :targets, :dashboard_id, :settings

  #after_initialize :set_defaults
  
  class << self

    def for_dashboard(id)
      where(:dashboard_id => id)
    end

  end
end

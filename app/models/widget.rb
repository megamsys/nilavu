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

   # flatten settings hash
  def as_json(options = {})
    result = super(:except => :settings)
    result.merge!((settings || {}).stringify_keys)
    result
  end

  end
end

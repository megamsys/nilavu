class Widget < ActiveRecord::Base
   belongs_to :cloud_book

  serialize :settings
  serialize :targets, Array

  validates :name, :kind, :source, :dashboard_id, :presence => true

  attr_accessible :name, :kind, :source, :size, :targets, :dashboard_id, :range, :widget_type

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

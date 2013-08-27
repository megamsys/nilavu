class Dashboard < ActiveRecord::Base   

  serialize :layout
  validates :name, :presence => true 

  attr_accessible :name, :layout

  protected

  def set_defaults
    self.layout = [] unless self.layout
  end
end

class Dashboard < ActiveRecord::Base
  belongs_to :user
  
  has_many :widgets, :dependent => :destroy

  serialize :layout
  validates :name, :presence => true

  after_initialize :set_defaults

  attr_accessible :name, :layout, :user_id

  protected

  def set_defaults
    self.layout = [] unless self.layout
  end
end

module CockpitControlable
  extend ActiveSupport::Concern

  included do
    attr_writer :controls, :appcontrols
  end

  def controls
    puts "--- requests hack --"
  end

  def appcontrols
    puts "--- requests hack --"
  end

end

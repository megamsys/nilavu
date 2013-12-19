module Packable
  extend ActiveSupport::Concern

  included do
    attr_writer :packed, :packed_h
  end

  def packed(subpacker_class, validate=false, args)
    instance = subpacker_class.constantize.new(args)
    instance.meatball(validate)
  end

  def packed_h(subpacker_class, args)
    instance = subpacker_class.constantize.new(args)
    instance.meatball_h
  end

end
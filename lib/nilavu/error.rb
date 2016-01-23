module Nilavu
  # The base class for all Megam errors. It can wrap another exception
  class Error < RuntimeError
    attr_accessor :original
    def initialize(message, original=nil)
      super(message)
      @original = original
    end
  end

  module ExternalFileError
    # This module implements logging with a filename and line number. Use this
    # for errors that need to report a location in a non-ruby file that we
    # parse.
    attr_accessor :line, :file, :pos

    # May be called with 3 arguments for message, file, line, and exception, or
    # 4 args including the position on the line.
    #
    def initialize(message, file=nil, line=nil, pos=nil, original=nil)
      if pos.kind_of? Exception
        original = pos
        pos = nil
      end
      super(message, original)
      @file = file unless (file.is_a?(String) && file.empty?)
      @line = line
      @pos = pos
    end
    def to_s
      msg = super
      @file = nil if (@file.is_a?(String) && @file.empty?)
      if @file and @line and @pos
        "#{msg} at #{@file}:#{@line}:#{@pos}"
      elsif @file and @line
        "#{msg} at #{@file}:#{@line}"
      elsif @line and @pos
        "#{msg} at line #{@line}:#{@pos}"
      elsif @line
        "#{msg} at line #{@line}"
      elsif @file
        "#{msg} in #{@file}"
      else
        msg
      end
    end
  end

  class MegamGWError < Nilavu::Error; end
  class CephError < Nilavu::Error; end
  class RiakError < Nilavu::Error; end
  class VerticeHealthCheckError < Nilavu::Error; end

  class ResourceError < Nilavu::Error; end

  # An error class for when I don't know what happened.  Automatically
  # prints a stack trace when in debug mode.
  class DevError < Nilavu::Error
    include ExternalFileError
  end
end

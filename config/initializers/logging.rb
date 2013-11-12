class Logger
  def format_message(severity, timestamp, progname, msg)
    "[Debug] #{timestamp} #{msg}\n"
  end
end

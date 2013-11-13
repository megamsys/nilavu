class Logger
  def format_message(severity, timestamp, progname, msg)
    "[info] #{timestamp} #{msg}\n"
  end
end

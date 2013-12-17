class Logger
  def format_message(severity, timestamp, progname, msg)
    "[#{severity}] #{timestamp} #{msg}\n"
  end
end

module GlobalExceptions

  def catch_exceptions
    yield
  rescue StandardError => std
    log_exception(std)
  end

  def log_exception(exception)
    trace = filter_exception(exception) if exception
    unless trace.empty?
      log_trace(trace)
      ascii_bomb
    end
  end

  #just show our stuff .
  def filter_exception(exception, by='nilavu')
    logger.debug "\033[1m\033[32m#{exception.message}\033[0m\033[22m"
    exception.backtrace.grep(/#{Regexp.escape("#{by}")}/)
  end

  def log_trace(trace)
    trace = (trace.map { |ft| ft.split('/').last }).join("\n")
    logger.debug "\033[1m\033[36m#{trace}\033[0m\033[22m"
  end

  def ascii_bomb
    logger.debug ''"\033[31m
       ,--.!,
    __/   -*-
	,####.  '|`
	######
	`####'                !\033[0m\033[1mWe flunked!\033[22m
"''
  end
end

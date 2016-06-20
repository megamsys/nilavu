class Scrubber

  attr_accessor :data

  def after_scrubbed
    raise NotImplementedError
  end

  # can be used to hook in after registering honeypot
  #  this MUST be implemented for authenticators that do not
  #  trust email
  def scrubbed
  end

  # hook used for registering data,
  #  without this we can not do scurbbing
  def register_honeypot(data)
    raise NotImplementedError
  end
end

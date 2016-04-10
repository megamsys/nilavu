class EmailCheckerService

  def check_email(email)
    if email && email.length > 0
      check_email_availability(email)
    end
  end

  def check_email_availability(email)
    if User.new_from_params({:email => email.downcase, :password => "drgruisback"}).email_available?
      { available: true, is_developer: is_developer?(email) }
    end
  rescue ApiDispatcher::NotReached
    { available: false }
  rescue ApiDispatcher::Flunked => f
    { available: !f.h401?, is_developer: is_developer?(email) }
  end

  def is_developer?(value)
    Rails.configuration.respond_to?(:developer_emails) && Rails.configuration.developer_emails.include?(value)
  end

end

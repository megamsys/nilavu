class EmailCheckerService

  def check_email(email)
    if email && email.length > 0
      check_email_availability(email)
    end
  end

  def check_email_availability(email)
    if User.new({:email => email.downcase}).email_available?
      { available: true, is_developer: is_developer?(email) }
    else
      { available: false }
    end
  end

  def is_developer?(value)
    Rails.configuration.respond_to?(:developer_emails) && Rails.configuration.developer_emails.include?(value)
  end

end

class Results
  attr_reader :response
  attr_writer :result_hash
  attr_writer :mobile_number
  attr_writer :error

  def initialize(response, mobile_number)
    @mobile_number = mobile_number

    parse_body(response.body) if should_parse?(response)
  end

  def succeeded?
    @result_hash["smsStatus"] == "MESSAGE_SENT"
  end

  def pin_id
    result_hash[:pinId]
  end

  private

  def should_parse?(response)
    case response
    when Net::HTTPSuccess
      true
    else
      raise Nilavu::NotFound, t('signup.otp_failure')
    end
  end

  def parse_body(raw_body)
    @result_hash = MultiJson.load(raw_body)
  end
end

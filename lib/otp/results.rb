class Results
  attr_reader :response
  attr_writer :result_hash
  attr_writer :mobile_number
  attr_writer :error

  def initialize(response, mobile_number)
    @mobile_number = mobile_number
    @result_hash = {}
    parse_body(response.body) if should_parse?(response)
  end

  def succeeded?
    @result_hash["smsStatus"] == "MESSAGE_SENT"
  end

  def correct_pin?
    @result_hash["verified"]
  end

  def error
    return @result_hash["pinError"] if @result_hash.has_key?("pinError")
    return @result_hash["ncStatus"] if (@result_hash.has_key?("smsStatus") && @result_hash["smsStatus"] == "MESSAGE_NOT_SENT")
  end

  def pin_id
    @result_hash["pinId"]
  end

  private

  def should_parse?(response)
    case response.code
    when 200
      true
    else
      false
    end
  end

  def parse_body(raw_body)
    @result_hash = MultiJson.load("#{raw_body}")
  end
end

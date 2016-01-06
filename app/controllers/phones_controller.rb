class PhonesController < ApplicationController

  def new
   	pin_send = Nilavu::OTP::Infobip.new.send_pin("#{params['mobile_number']}")
	if pin_send == "Message sending failed"
		toast_error(signup_path, "OTP auth pin Message sending failed")
	else
		session[:otp_pin_id] = pin_send
	end
  end

  def create
	pin_verify = Nilavu::OTP::Infobip.new.verify_pin(session[:otp_pin_id], params['pin'])
	unless pin_verify
		toast_error(signup_path, "OTP auth pin Message sending failed")
	end
  end

end

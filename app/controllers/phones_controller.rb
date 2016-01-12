class PhonesController < ApplicationController
  def new
   	pin_send = Nilavu::OTP::Infobip.new.send_pin("#{params['mobile_number']}")
	if pin_send == "Message sending failed"
		flash[:error] = "Sorry! Your pin wasn't sent!"
		render js: "window.location = '#{signup_path}'"
	else
		session[:otp_pin_id] = pin_send
	end
  end

  def create
	pin_verify = Nilavu::OTP::Infobip.new.verify_pin(session[:otp_pin_id], params['pin'])
	unless pin_verify
		flash[:error] = 'Sorry! Your pin is wrong!'
		render js: "window.location = '#{signup_path}'"
	end
  end
end

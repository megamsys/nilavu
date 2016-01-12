class PhonesController < ApplicationController

  def new
   	pin_send = Nilavu::OTP::Infobip.new.send_pin("#{params['mobile_number']}")
	if pin_send == "Message sending failed"
		redirect_to(signup_path, :flash => { :error => "Sorry! OTP-PIN sending Failed!"}, format: 'js')
	else
		session[:otp_pin_id] = pin_send
	end
  end

  def create
	pin_verify = Nilavu::OTP::Infobip.new.verify_pin(session[:otp_pin_id], params['pin'])
	unless pin_verify
		redirect_to(signup_path, :flash => { :error => "Sorry! Your pin is wrong!"}, format: 'js')
	end
  end

end

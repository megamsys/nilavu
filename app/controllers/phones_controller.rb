class PhonesController < ApplicationController
  def new
    pin_send = Nilavu::OTP::Infobip.new.send_pin("#{params['mobile_number']}")
    if pin_send == "Message sending failed"
	flash[:error] = 'Sorry! OTP-PIN sending failed!'
	render js: "window.location = '#{params['redirect']}'"
    else
      session[:otp_pin_id] = pin_send
      session[:mobile_number] = "#{params['mobile_number']}"
    end
  end

  def create
    pin_verify = Nilavu::OTP::Infobip.new.verify_pin(session[:otp_pin_id], params['pin'])
	@path = "#{params['redirect']}"
    unless pin_verify
	flash[:error] = 'Sorry! Your pin is wrong!'
	render js: "window.location = '#{@path}'"
    end
  end
end

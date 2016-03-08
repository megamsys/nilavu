class PhonesController < ApplicationController

  skip_before_filter :redirect_to_login_if_required

  def new
    result = Infobip.send_pin_to(params[:mobile_number])

    return store_pin_mobile if result.succeeded?

    flash[:error] = result.error
    render js: "window.location = '#{params['redirect']}'"
  end

  def create
    result = Infobip.verify_pin(session[:otp_pin_id], params[:pin])

    return if result.succeeded?

    flash[:error] = result.error
    render js: "window.location = '#{params['redirect']}'"
  end

  private

  def store_pin_mobile(pin, mobile_number)
    session[:otp_pin_id] = pin
    session[:mobile_number] = mobile_number
  end

end

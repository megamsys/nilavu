class PhonesController < ApplicationController

  skip_before_filter :redirect_to_login_if_required
  skip_before_filter  :verify_authenticity_token, only: [:create]	#fix for "Can't verify CSRF token authenticity"

  def new
    result = Infobip.send_pin_to(params[:mobile_number])
    return store_pin_mobile(result.pin_id, params[:mobile_number]) if result.succeeded?
    flash[:error] = result.error
    render js: "window.location = '#{params['redirect']}'"
  end

  def create
    result = Infobip.verify_pin(session[:otp_pin_id], params[:pin], session[:mobile_number])
    @path = "#{params[:redirect]}"
    return if result.correct_pin?
    flash[:error] = result.error
    render js: "window.location = '#{@path}'"
  end

  private

  def store_pin_mobile(pin, mobile_number)
    session[:otp_pin_id] = pin
    session[:mobile_number] = mobile_number
  end

end

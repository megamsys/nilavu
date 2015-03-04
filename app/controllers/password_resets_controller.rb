class PasswordResetsController < ApplicationController
  #respond_to :html, :js

  def create
    user = User.find_by_email(params[:email])
    if user
        if "#{Rails.configuration.support_email}".chop!
          user.send_password_reset
        end
    else
      logger.debug "Email doesn't match with megam account"
      @error = "not_match"
    #flash[:error] = "Hey ! Please Enter your correct megam email"
    #redirect_to root_url
    #redirect_to root_url, :gflash => { :error => { :value => "Please Enter your correct megam email", :sticky => false, :nodom_wrap => true } }
    end
  end

  def edit
    @user = User.find_by_password_reset_token!(params[:id])
  end

  def update
    @user = User.find_by_password_reset_token!(params[:id])
    if @user.password_reset_sent_at < 2.hours.ago
      redirect_to new_password_reset_path, :alert => "Password reset has expired."
    elsif @user.update_attributes(params['user'])
      redirect_to root_url, :notice => "Password has been reset!"
    else
      render :edit
    end
  end
end


class PasswordResetsController < ApplicationController
  #respond_to :html, :js

  def create
	@user = User.new
    user = @user.find_by_email(params[:email])
    if user
        if "#{Rails.configuration.support_email}".chop!
          @user.send_password_reset(params[:email])
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
	user = User.new
    @user = user.find_by_password_reset_token(params[:id], params[:email])
	puts "Password reset Edit =============> "
	puts @user.inspect
	@user
  end

  def update
	user_obj = User.new
    @user = user_obj.find_by_password_reset_token(params[:id], params[:email])
    if @user["password_reset_sent_at"] < 2.hours.ago
      redirect_to signin_path, :alert => "Password reset has expired."
    elsif true
	update_options = { "password" => user_obj.password_encrypt(params[:password]), "password_confirmation" => user_obj.password_encrypt(params[:password_confirmation]) }
        res_update = user_obj.update_columns(update_options, params[:email])
      redirect_to root_url, :notice => "Password has been reset!"
    else
      render :edit
    end
  end
end


class MobileAvatarsController < ApplicationController

  before_action :add_authkeys_for_api, only: [:index]

  def create
     render json: activate_mobileavatar(params)
  end

  private

  def activate_mobileavatar(params)
      MobileAvatarActivator.new(current_user, params).finish
  end

end

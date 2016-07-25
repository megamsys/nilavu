class MobileAvatarsController < ApplicationController
  include MobileAvatarActivator

  before_action :add_authkeys_for_api, only: [:index]

  def create
     render json: activate_mobileavatar(params)
  end
  
end

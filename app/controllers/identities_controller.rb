class IdentitiesController < ApplicationController
  def new
    @identity = env['omniauth.auth']
#    render :text => identity.inspect
  end
end

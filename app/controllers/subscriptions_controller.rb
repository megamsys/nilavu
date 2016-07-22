class SubscriptionsController < ApplicationController

  skip_before_filter :check_xhr

  def entrance
    #puts current_user.active?
    #puts current_user.approved?
    render 'subscriptions/entrance'
  end
end

# this class is used by the billable controllers, it controls how
# an user subcribes with the biller

class Billy::Subscriber

  def subscribe(subscribe_options)
    raise NotImplementedError
  end

  #  can be used to hook in after the subscription process
  #  is complete
  def after_subscription(user, subscribed)
    # not required
  end

  def update(update_options)
    raise NotImplementedError
  end

  #  can be used to hook in after the update subscription  process
  #  is complete
  def after_update(user, updated)
    # not required
  end

  # hook used for registering this subscriber
  # without this we can not place an order
  def register()
    raise NotImplementedError
  end
end

# this class is used by the billable controllers, it controls how
# an user subcribes with the biller

class Biller::Subscriber

  def subscribe(subscribe_options)
    raise NotImplementedError
  end

  #  can be used to hook in after the subscription process
  #  is complete
  def after_subscribe(subscribed)
    # not required
  end

  def update(update_options)
    raise NotImplementedError
  end

  #  can be used to hook in after the update subscription  process
  #  is complete
  def after_update(updated)
    # not required
  end
end

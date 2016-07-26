# this class is used by the billable controllers, it controls how
# an user onboards with the biller

class Billy::Orderer

  def onboard(onboard_options)
    raise NotImplementedError
  end

  #  can be used to hook in after the onboard process
  #  is complete
  def after_onboard(user, onboard)
    # not required
  end

  # hook used for registering this orderplacer
  # without this we can not place an order
  def register()
    raise NotImplementedError
  end
end

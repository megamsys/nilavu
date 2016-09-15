# this class is used by the subscriptions controllers, it controls how
# an user onboard with the third-party
module Biller; end

class Biller::Onboarder

  def onboard(onboard_options)
    raise NotImplementedError
  end

  #  can be used to hook in after the onboard process
  #  is complete
  def after_onboard(onboarded)
    # not required
  end

end

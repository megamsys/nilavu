# this class is used by the billable controller, it controls how
# an user shops products and knows the payment methods provided by a biller
module Biller; end

class Biller::Shopper

  def shop(shopper_options)
    raise NotImplementedError
  end

  #  can be used to hook in after the order process
  #  is complete
  def after_shop(user, order)
    # not required
  end
end

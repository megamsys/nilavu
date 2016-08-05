# this class is used by the billable controllers, it controls how
#  an order placement interacts with the biller

class Biller::Orderer

  def order(order_options)
    raise NotImplementedError
  end

  #  can be used to hook in after the order process
  #  is complete
  def after_order(user, order)
    # not required
  end
end

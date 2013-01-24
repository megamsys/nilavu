class BillingController < ApplicationController

  add_breadcrumb "Home", :root_path

  def pricing
	add_breadcrumb "Pricing", pricing_path
  end

  def account
	add_breadcrumb "Account", account_path
  end

  def history
	add_breadcrumb "History", history_path
  end
end

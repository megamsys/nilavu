class DisasterRecoveryController < ApplicationController
  def drbd_config
  breadcrumbs.add "Home", "#", :class => "fa fa-home", :target => "_self"
    breadcrumbs.add "MarketPlace", marketplaces_path, :target => "_self"
      @my_apps = []
      cloud_books = current_user.apps.order("id DESC").all
      if cloud_books.any?
        @my_apps = cloud_books.map {|c| c.name}
        @my_apps = @my_apps.uniq
      else
        @my_apps << "No apps created."
      end
  end
  
  def drbd_submit
  	puts "DRBD SUBMIT PARAMS -------------------------- > "
  	puts params
  end
end

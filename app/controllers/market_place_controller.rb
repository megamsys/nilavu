class MarketPlaceController < ApplicationController
  respond_to :html, :js
  def index

  end

  def new
    if current_user.onboarded_api
      @book =  current_user.cloud_books.build
      breadcrumbs.add "Home", "#"
      breadcrumbs.add "Market Place", new_market_place_path
      @products = Product.all
      @category = {}
      @products.each do |product|
        if product.market_place
          if @category.has_key?(product.category)
          @category[product.category] ||= []
          @category[product.category] << product.name
          else
          @category[product.category] ||= []
          @category[product.category] << product.name
          end
        end
      end
    else
      redirect_to cloud_dashboards_path, :gflash => { :warning => { :value => "You need an API key to launch an app from marketplace. Click Profile, and generate a new API key", :sticky => false, :nodom_wrap => true } }
    end

  end
end

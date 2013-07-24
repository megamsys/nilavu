class CloudBooksController < ApplicationController

  respond_to :html, :js
  add_breadcrumb "Home", :root_path
  
  def new
    @book =  current_user.cloud_books.build
   #@book = CloudBook.new
    logger.debug "@BOOK ++> #{@book.inspect}"
    add_breadcrumb "first step", cloud_book_create_path    
    
  end  
    
    def create    
      @book = current_user.cloud_books.create(params[:cloud_book])            
    if @book.save
      redirect_to users_dashboard_url, :gflash => { :success => { :value => "Hai  #{current_user.first_name}. Created cloud book #{@book.platformapp} successfully.", :sticky => false, :nodom_wrap => true } }
    else           
      render 'new'
    end
  end
  
end

class CloudBooksHistoriesController < ApplicationController

 add_breadcrumb "Home", :root_path
  def running_cloud   
    #@run = current_user.cloud_books
         # @apps = @run.cloud_runs.create(:book_name => params[:book_name])        
        puts current_user.cloud_books.inspect
        #current_user.cloud_books.build_cloud_books_histories
       current_user.cloud_books.cloud_books_histories.create(:book_id => params[:book_id], :book_name => params[:book_name])
   
    add_breadcrumb "Cloud Run", running_cloud_path
    #@cloud_runs = current_user.cloud_runs
  #Resque.enqueue(`rake resque:work QUEUE='*'`)
  #Resque.enqueue(CloudRest)
  end

  def worker
    Resque.enqueue(CloudRest)
  end

end

class CloudBooksHistoriesController < ApplicationController

 add_breadcrumb "Home", :root_path
  def running_cloud
    puts "#{params}"   
    #@run = current_user.cloud_books
         # @apps = @run.cloud_runs.create(:book_name => params[:book_name])        
        
       current_user.cloud_books.cloud_books_histories.build(:book_name => params[:book_name])
   
    add_breadcrumb "Cloud Run", running_cloud_path
    #@cloud_runs = current_user.cloud_runs
  #Resque.enqueue(`rake resque:work QUEUE='*'`)
  #Resque.enqueue(CloudRest)
  end

  def worker
    Resque.enqueue(CloudRest)
  end

end

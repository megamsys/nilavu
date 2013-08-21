class ErrorsController < ApplicationController
 
  def not_found
    render_404
  end
 
   
  def internal_error
    render_500
  end
 
end
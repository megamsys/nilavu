module Sources
  module Totalbooks
    class Usermodel
      def get(options = {})
        widget  = Widget.find(7)       
        dashboard_id = widget.dashboard_id        
        dashboard = Dashboard.find(dashboard_id)       
        user_id = dashboard.user_id        
         c = CloudBook.where(:users_id => user_id).count        
        { :value => c }
      end

    end

  end
end

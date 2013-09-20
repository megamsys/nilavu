module Sources
  module Totalbooks
    class Usermodel < Sources::Totalbooks::Base
      def get(options = {})
        puts "+++++++++++++++++++++++++++++++++++++++++++++++++++"
        puts options[:widgetid].to_i
        #widget  = Widget.find(options[:widgetid].to_i) 
        widget  = Widget.find(1)      
        dashboard_id = widget.dashboard_id        
        dashboard = Dashboard.find(dashboard_id)       
        user_id = dashboard.user_id        
         c = CloudBook.where(:users_id => user_id).count        
        { :value => c }
      end

    end

  end
end

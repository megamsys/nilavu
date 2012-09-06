metadata :name        => "Cloud Identity Agent",
           :description => "Cloud identity service for Megam",
           :author      => "Kishorekumar Neelamegam",
           :license     => "GPLv3",
           :version     => "0.1",
           :url         => "http://blog.megam.co",
           :timeout     => 60
  

action "listrealms", :description => "Lists all the realms" do
   input :msg,
          :prompt      => "Service Name",
          :description => "The service to list the realms for",
          :type        => :string,
          :validation  => '^[a-zA-Z\-_\d]+$',
          :optional    => false,
          :maxlength   => 30
 
    output :msg,
    	   :status,
           :description => "The message we received",
           :display_as  => "Message"
end

action "showrealm", :description => "Shows the details of a realm" do
   input :msg,
          :prompt      => "Service Name",
          :description => "The service to show realm details status for",
          :type        => :string,
          :validation  => '^[a-zA-Z\-_\d]+$',
          :optional    => false,
          :maxlength   => 30
 
    output :msg,
     	   :status,
           :description => "The message we received",
           :display_as  => "Message"
end

action "createrealm", :description => "Creates a realm" do
   input :msg,
          :prompt      => "Service Name",
          :description => "The service to create realm for",
          :type        => :string,
          :validation  => '^[a-zA-Z\-_\d]+$',
          :optional    => false,
          :maxlength   => 30
 
    output :msg,
           :status,
           :description => "The message we received",
           :display_as  => "Message"
end

action "showbrand", :description => "Show the brand details for a realm" do
   input :msg,
          :prompt      => "Service Name",
          :description => "The service to show brand details for",
          :type        => :string,
          :validation  => '^[a-zA-Z\-_\d]+$',
          :optional    => false,
          :maxlength   => 30
 
    output :msg,
           :status,
           :description => "The message we received",
           :display_as  => "Message"
end

action "createbrand", :description => "Creates a brand" do
   input :msg,
          :prompt      => "Service Name",
          :description => "The service to create brand for",
          :type        => :string,
          :validation  => '^[a-zA-Z\-_\d]+$',
          :optional    => false,
          :maxlength   => 30
 
    output :msg,
           :status,
           :description => "The message we received",
           :display_as  => "Message"
end
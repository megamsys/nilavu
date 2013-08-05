#List all the predef cloud names per email
class ListPredefClouds

  @queue = "predefclouds"
  #this returns a Megam::PredefCloud object
  def self.perform(list_predefclouds={})
    Megam::Config[:email] = list_predefclouds[:email]
    Megam::Config[:api_key] = list_predefclouds[:api_key]
    Megam::PredefCloud.list
  end

end
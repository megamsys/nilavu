#Show a predef by name
class FindPredefsByName

  @queue = "predefclouds"
  
  #this returns a Megam::PredefCloud object
  def self.perform(show_predef={})
    Megam::Config[:email] = show_predef[:email]
    Megam::Config[:api_key] = show_predef[:api_key]
    Megam::Predef.show
  end

end
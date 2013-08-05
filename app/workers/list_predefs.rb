#List all the predefs
class ListPredefs

  @queue = "predefs"
  #this returns a Megam::PredefCloud object
  def self.perform(list_predefs={})
  #only do this if there are keys (email/apikey)
    Megam::Config[:email] = list_predefs[:email]
    Megam::Config[:api_key] = list_predefs[:api_key]
    Megam::Predef.list
  end

end
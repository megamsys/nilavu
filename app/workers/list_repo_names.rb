class ListRepoNames  
  def self.perform(username, password)    
      @excon_res = Megam::ScmmRepo.list(username, password)    
      @excon_res
  end
end

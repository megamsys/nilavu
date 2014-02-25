class ListRepoNames  
  def self.perform(username, password)    
      @excon_res = Megam::Repo.list(username, password)    
      @excon_res
  end
end

module Githubber

  ## this has a limitation to show only 30 urls
  ## redesign ui to accomodate paging.
  def self.repos(token)
    if cl = client(token)
      cl.repos.all.collect(&:clone_url)
    end
  end

  private

  def self.client(tok)
    @client = Github.new oauth_token: tok
  end
end

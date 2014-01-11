module DashboardsHelper
  def launched(userID)
    a=Array.new
    @node =  FindNodesByEmail.perform(force_api[:email], force_api[:api_key])
    if @node.class == Megam::Error
      { "books" => ["You have no books"] }
    else
      @node.each do |n|
        a << n.node_name
      end
      { "books" => a }
    end
  end
end

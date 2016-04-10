module HttpErrors

  def is_http_403?(response)
      response.is_a?(Megam::API::Errors::Forbidden)
  end

  def is_http_401?(response)
      response.is_a?(Megam::API::Errors::Unauthorized)
  end

  def is_http_404?(response)
     response.is_a?(Megam::API::Errors::NotFound)
  end
end

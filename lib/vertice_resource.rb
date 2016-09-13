module VerticeResource
  def megfunction
    NotImplementedError
  end

  def megaction
    NotImplementedError
  end

  def passthru?
    false
  end

  def invoke_submit
    Rails.logger.debug("START #{megfunc}.#{megact}")
    debug_print(parameters)
    Rails.logger.debug("\033[01;35mRUN_NOW #{megfunc}.#{megact} \33[0;34m")
    return submit(megfunc, megact, parameters).data
  end

  private

  def submit(jlaz, jmethod, jparams)
    Megam::Log.level(Rails.configuration.log_level)
    api_jlaz = jlaz.constantize
    unless api_jlaz.respond_to?(jmethod)
      Rails.logger.debug "API  #{jlaz}.#{jmethod} not found."
      fail Nilavu::NotFound
    end

    api_jlaz.send(jmethod, jparams)
  end

end

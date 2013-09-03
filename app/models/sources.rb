module Sources
  extend self
 
  def plugin_clazz(type, name)    
    "Sources::#{type.camelize}::#{name.camelize}".constantize  
  end

end

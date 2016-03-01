class FavourizeItem
  def initialize(value)
    parts = value.split(',')
    @ram =  initialize_flavs(parts[0])
    @core = initialize_flavs(parts[1])
    @hdd =  initialize_hdd(parts[2])
  end

  attr_reader :ram, :core, :hdd

  def has_ssd?
    @hdd.include? 'ssd'
  end

  def has_sata?
    @hdd.include? 'sata'
  end

  #def specific_category
  #  name.split('/')[1]
  #end

  private

  def initialize_flavs(value)
    if value
      if value.start_with?('[')
        value[1..-1] # all but the leading [
      else
        value
      end
    end
  end

  def initialize_hdd(value)
    if value
      if value.ends_with?(']')
        value.chop # all but the ending ]
      else
        value
      end
    end
  end


end

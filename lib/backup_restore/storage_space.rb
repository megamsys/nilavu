class StorageSpace

  attr_reader :buckets_count
  attr_reader :buckets_size
  attr_reader :buckets_size_humanized

  def initialize(weightings=nil)
    @weightings = weightings
end

  # Calculate the storage for all buckets or bucket_items
  def calculate(min_count=0)
     @buckets_size = update_buckets_size(min_count)

    @buckets_count = update_buckets_count(min_count)

    @buckets_size_humanized = @buckets_size.to_s(:human_size)
  end


  private


  def update_buckets_count(min_size)
    return min_size unless @weightings.present?

    @weightings.count
  end

  def update_buckets_size(min_count)
    return min_count unless @weightings.present?

    weighed = @weightings.collect {|count| count.respond_to?(:size) ? count.size : "0"}

    @buckets_size = weighed.reduce(:+)
  end


  #def consolidated_totalsummary(email)
  #  summary = consolidated_totalsummary(email)

  #  return unless summary.present?

  #  summary.symbolize_keys!

  #  GWUser.usage(email)
  #end
end

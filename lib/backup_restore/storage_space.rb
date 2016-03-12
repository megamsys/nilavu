class StorageSpace

  attr_reader :buckets_count
  attr_reader :buckets_size
  attr_reader :buckets_size_humanized

  def initialize(weightings=nil)
    @weightings = weightings
  end

  # Calculate the storage for all buckets or bucket_items
  def calculate(min_count=0)
    update_buckets_size

    update_buckets_count
  end


  private

  def update_buckets_size(min_size)
    @weightings.size || min_size
  end

  def update_buckets_count(min_count)
    raise Nilavu::NotFound unless @weightings

    weighed = @weightings.collect {|count| count.respond_to?(:size) ? count.size : "0"}

    @buckets_size = weighed.reduce(:+)

    @buckets_size_humanized = @bucket_size.to_s(:human_size)
  end


  def consolidated_totalsummary(email)
    summary = consolidated_totalsummary(email)

    return unless summary.present?

    summary.symbolize_keys!

    GWUser.usage(email)
  end
end

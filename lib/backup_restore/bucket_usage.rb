class BucketUsage
  attr_reader :name, :size, :size_humanized, :count

  def initialize(bucket)
    @name = bucket.name
    @size = size_all_objects(bucket)
    @size_humanized = @size.to_s(:humanized)
    @count = count_all_objects(bucket)
  end

  private

  def size_all_objects(bucket)
    bucket.objects.inject(0) { |n, bobject| n + bobject.size.to_i }
  end

  def count_all_objects(bucket)
    bucket.objects.count
  end
end

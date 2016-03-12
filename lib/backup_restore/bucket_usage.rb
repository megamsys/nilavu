class BucketUsage
  attr_reader :name, :size, :count

  def initialize(bucket)
    @name = bucket.name
    @size = size_all_objects(bucket).to_s(:human_size)
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

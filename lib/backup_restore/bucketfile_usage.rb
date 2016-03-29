class BucketfileUsage

  attr_reader :key
  attr_reader :name
  attr_reader :size
  attr_reader :content_type
  attr_reader :last_modified
  attr_reader :download_url


  def initialize(bucketobj)
    @key = bucketobj.key
    @name = bucketobj.full_key
    @size = bucketobj.size.to_i
    @content_type = bucketobj.content_type
    @last_modified = bucketobj.last_modified
    @download_url = bucketobj.temporary_url # this isn't there in the S3 object.
  end

  def size_with_units
    @size.to_s(:human_size)
  end

  def to_s
    [:key,:name,size_with_units,:content_type,:last_modified].each{|k| send("#{k}")}
  end
end

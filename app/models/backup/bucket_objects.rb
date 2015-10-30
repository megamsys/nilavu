module Backup
class BucketObjects < BackupService
  attr_reader :bucket, :name

  def initialize(params)
    super(params)
    @name = params[:bucket_name]
    @bucket = find(@name)
  end

  def list
    bucket.objects
  end

  def list_detail
    formatted_objc = []
    list.each do |objs_in_bucket|
        formatted_objc << format_obj(get(@name))
    end
    formatted_objc
  end

  def create(new_object)
    object = bucket.objects.build(new_object.original_filename)
    object.content = open(new_object)
    object.save
  end

  def get(name)
    object = bucket.objects.find("#{name}")
  end

  def delete(name)
    object = bucket.objects.find("#{name}")
    object.destroy
  end

  def download(name)
    object = bucket.objects.find("#{name}")
    object.content
  end

  private
  def bucket
    @bucket
  end

  # we have trap BucketsNotFound
  def find(tmp_bucket)
    cephs3.buckets.find("#{tmp_bucket}")
  end


  def format_obj(obj)
    {:key => "#{obj.key}",
      :object_name => "#{obj.full_key}",
      :size => "#{obj.size}",
      :content_type => "#{obj.content_type}",
      :last_modified => "#{obj.last_modified}",
      :download_url => "#{obj.temporary_url}"
    }
  end
end
end

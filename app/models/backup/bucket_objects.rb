module Backup
  class BucketObjects < BackupService
    attr_reader :bucket, :bucketobjects
    def initialize(params)
      super(params)
      @bucket = find_bucket(params[:id])
      @bucketobjects = list
      @saved_object_size = 0
    end

    def list
      @bucket.objects
    end

    #i don't know where this is used.
    def detail
      result ||= @bucketobjects.map { |bobject| parse(find_object(bobject))}
      { total_objects: @bucketobjects.count, objects: result||{}, total_size: total.to_s(:human_size)}
    end

    def create(data)
      bobject = bucketobjects.build(data.original_filename)
      bobject.content = open(data) # return file not found.
      bobject.save
    end

    def delete(name)
      find_object("#{name}").destroy
    end

    def download(name)
      find_object("#{name}").content
    end

    private

    # we have trap BucketsNotFound
    def find_bucket(name)
      buckets.find("#{name}")
    end

    def bucket
      @bucket
    end

    def bucketobjects
      @bucketobjects
    end

    def find_object(bobjname)
      @bucket.objects.find("#{bobjname.key}")
    end

    def parse(bobject)
      @saved_object_size += bobject.size.to_i
      {:key => "#{bobject.key}",
        :object_name => "#{bobject.full_key}",
        :size => "#{bobject.size.to_i.to_s(:human_size)}",
        :content_type => "#{bobject.content_type}",
        :last_modified => "#{bobject.last_modified}",
        :download_url => "#{bobject.temporary_url}"
      }
    end

    def total
      @saved_object_size ||= @saved_object_size.reduce(:+)
    end
  end
end

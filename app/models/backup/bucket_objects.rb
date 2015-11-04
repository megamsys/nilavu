module Backup
  class BucketObjects < BackupService
    attr_reader  :bucket, :bucketobjects

    def initialize(params)
      super(params)
      #@bucket = find_bucket(params[:id])
      @bucket = find_bucket("u_ajax")
      @bucketobjects = list
    end

    def list
      bucket.objects
    end
    
   #i don't know where this is used.
    def detail
      bucketobjects.map { |bobject| parse(find_object(bobject))}
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
      bucketobjects.find("#{bobjname}")
    end

    def parse(bobject)
      {:key => "#{bobject.key}",
        :object_name => "#{bobject.full_key}",
        :size => "#{bobject.size}",
        :content_type => "#{bobject.content_type}",
        :last_modified => "#{bobject.last_modified}",
        :download_url => "#{bobject.temporary_url}"
      }
    end
  end
end

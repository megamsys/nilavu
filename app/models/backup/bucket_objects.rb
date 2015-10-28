class BucketObjects < BackupFascade
    attr_reader bucket

    def initialize(params)
      @bucket = find(params[:bucket_name])
      super(params)
    end

    def list(name)
      bucket.objects
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
end

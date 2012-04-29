class Picture < ActiveRecord::Base
  
  def self.uploadToAWS(upload, album)
    file_name = upload.original_filename
    user = User.find_by_id(album.user_id)
    bucket_name = 'user' + user.id.to_s + '_album' + album.id.to_s
    s3 = AWS::S3.new(YAML.load_file('config/s3.yml'))
    if s3.buckets[bucket_name].exists?
      bucket = s3.buckets[bucket_name]
    else
      bucket = s3.buckets.create(bucket_name)
    end  
    photo = bucket.objects[file_name]
    photo.write(upload.read, :acl => :public_read)
    if photo.public_url
      url = photo.public_url.to_s
      picture = Picture.create!(:name => file_name,:internal_link => url, :user_id => user.id, :album_id => album.id)
      
    end
    picture
  end
  
  
  def self.handleUpload(upload,user_id)
    name = upload['datafile'].original_filename
    fakeName = user_id.to_s + "%$*" + name #DEBUG: be sure to do it differently

    directory = "photoStorage/"
    # create the file path
    path = File.join(directory, fakeName)
    # write the file
    File.open(path, "wb") { |f| f.write(upload['datafile'].read) }
    
    return [name, path] #name is real name without delimiter
  end 
end

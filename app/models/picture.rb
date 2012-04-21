class Picture < ActiveRecord::Base
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

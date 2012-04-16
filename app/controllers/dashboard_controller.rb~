class DashboardController < ApplicationController
  
  
  def index  #displaying facebook albums
    @selected_picture = params[:picture] || session[:picture] || {}
    session[:picture] = @selected_picture
    user_id = session[:user_id]
    # crowd albums part
    @crowdAlbums = User.find_by_id(user_id).albums
    
    # facebook albums part
    @albums = nil
    token = session[:token]
    @user = User.find_by_id(user_id)
    @user_name = User.find_by_id(user_id).name
    if session[:token]
      result = @user.grap_facebook_albums(token)
      @albums = result
    else
    end
    @pictureSelected = Picture.find(@selected_picture.keys) 
  end
  
  def selectPhoto  #checkboxes page
    albumID = params[:album_id]
    targetAlbum = Album.find(albumID)
    @album_name = targetAlbum.name
    @picture_list = targetAlbum.pictures
    user_id = session[:user_id]
    @user_name = User.find(user_id).name
  end
  
  def uploadPhotoToNew #create new album and upload photo to it
    user_id = session[:user_id]
    @user = User.find(user_id)
    
    if request.post? #if the user clicked the "upload" button on the form
      #start create new album,new picture, and upload the file.
      newAlbum = Album.create!(:name => params[:albumName], :user_id => user_id) 
      
      #actually uploading photo
      namePathList = Picture.handleUpload(params[:upload], user_id)
      name = namePathList[0]
      path = namePathList[1]
      #render :text => "File has been uploaded successfully"
      
      #create new picture tuple
      newPicture = Picture.create!(:name => name,:internal_link => path, :user_id => user_id, :album_id => newAlbum.id)
           
      redirect_to :action => "selectPhoto", :album_id => newAlbum.id
      
      #should reder somewhere at the end
    end
  end
  
  def uploadPhotoToExisting     #upload photo to existing album
    user_id = session[:user_id]
    @user = User.find(user_id)
    
    if request.post? #if the user clicked the "upload" button on the form
      #start create new album,new picture, and upload the file.
      album_id = params[:album_id]
      
      #actually uploading photo
      namePathList = Picture.handleUpload(params[:upload], user_id)
      name = namePathList[0]
      path = namePathList[1]
      
      #create new picture tuple
      newPicture = Picture.create!(:name => name,:internal_link => path, :user_id => user_id, :album_id => album_id)
     
      redirect_to :action => "selectPhoto", :album_id => album_id
      
      #should reder somewhere at the end
    end
  end
  
  def selectAlbum   
    user_id = session[:user_id]
    user = User.find(user_id)
    albumList = user.albums
    @lol = [] #@lol is [[al.name,al.id],[al.name,al.id]]
    albumList.each do |al|
      @lol << [al.name,al.id]
    end
  end


end

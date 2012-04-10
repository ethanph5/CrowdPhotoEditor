class DashboardController < ApplicationController
  
  
  def index
    @albums = nil
    user_id = session[:user_id]
    token = session[:token]
    #debugger
    @user = User.find_by_id(user_id)
    @user_name = User.find_by_id(user_id).name
    if session[:token]
      result = @user.grap_facebook_albums(token)
      @albums = result
    else
    end
  end
  
  def selectPhoto
    albumID = params[:album_id]
    targetAlbum = Album.find_by_id(albumID)
    @album_name = targetAlbum.name
    @picture_list = targetAlbum.pictures
    user_id = session[:user_id]
    @user_name = User.find(user_id).name
  end
  
  def uploadPhotoToNew
    user_id = session[:user_id]
    @user = User.find(user_id)
    
    if request.post? #if the user clicked the "upload" button on the form
      #start create new album,new picture, and upload the file.
      newAlbum = Album.create!(:name => params[:albumName],:facebook_account_id => @user.authorization_id, :user_id => user_id) 
      
      #actually uploading photo
      namePathList = DataFile.save(params[:upload], user_id)
      name = namePathList[0]
      path = namePathList[1]
      #render :text => "File has been uploaded successfully"
      
      #create new picture tuple
      newPicture = Picture.create!(:name => name,:internal_link => path, :user_id => user_id, :album_id => newAlbum.id)
           
      redirect_to :action => "selectPhoto", :album_id => newAlbum.id
      
      #should reder somewhere at the end
    end
  end
  
  def uploadPhotoToExisting
    user_id = session[:user_id]
    @user = User.find(user_id)
    
    if request.post? #if the user clicked the "upload" button on the form
      #start create new album,new picture, and upload the file.
      album_id = params[:album_id]
      
      #actually uploading photo
      namePathList = DataFile.save(params[:upload], uid)
      name = namePathList[0]
      path = namePathList[1]
      render :text => "File has been uploaded successfully"
      
      #create new picture tuple
      newPicture = Picture.create!(:name => name,:internal_link => path, :user_id => user_id, :album_id => album_id, :query_id => nil)
     
      redirect_to :action => "selectPhoto", :album_id => album_id
      
      #should reder somewhere at the end
    end
  end
  
  def selectAlbum
    user_id = session[:user_id]
    @user = User.find(user_id)
    albumList = user.albums
    @lol = []
    albumList.each do |al|
      @lol << [al.name,al.id]
    end
  end


end

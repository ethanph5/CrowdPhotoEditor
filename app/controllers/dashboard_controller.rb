class DashboardController < ApplicationController
  before_filter :authenticate_user!, :except => [:welcome] 
  
  def welcome
  end
  
  def index  #displaying facebook albums
    session.delete(:tasks)
    session.delete(:results)
    if params[:selPic] = true
      session.delete(:picture)
    end

    if session[:picture]==nil
      session[:picture]=Hash.new
    end

    #@selected_picture = params[:picture] || session[:picture] || {}
    if params[:picture] !=nil 
      params[:picture].each do |key|
        session[:picture][key[0]] = 1
      end
    end
    @selected_picture=session[:picture] || {}
    
    #user_id = session[:user_id]
    user_id = current_user.id
    # crowd albums part
    @crowdAlbums = User.find_by_id(user_id).albums
    
    # facebook albums part
    @albums = nil
    auth = Authorization.find_by_user_id(user_id)
    if auth
      token = Authorization.find(current_user.id).token
    end
    @user = User.find_by_id(current_user.id)
    @user_name = User.find_by_id(current_user.id).name
    if token
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
    #user_id = session[:user_id]
    @user_name = User.find(current_user.id).name
  end
  
  def uploadPhotoToNew #create new album and upload photo to it
    user_id = current_user.id
    @user = User.find(user_id)
    
    if request.post? #if the user clicked the "upload" button on the form
      
      #first find if user already has album with that name
      if Album.find_by_name_and_user_id(params[:albumName], user_id)==nil
      
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

      else #if user already has album with same name
        flash[:error] = "You already have an album named #{params[:albumName]}, please enter a new name!"
        redirect_to :action => "uploadPhotoToNew"
      end


    end
  end
  
  def uploadPhotoToExisting     #upload photo to existing album
    user_id = current_user.id
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
    user_id = current_user.id
    user = User.find(user_id)
    albumList = user.albums
    @lol = [] #@lol is [[al.name,al.id],[al.name,al.id]]
    albumList.each do |al|
      @lol << [al.name,al.id]
    end
  end

  def specifyTask
    if session[:picture] == {}
      flash[:error] = "Please Select Photo(s) Before Specifying Task(s)"
      redirect_to :action => :index
    end

    @selected_picture = session[:picture]
    @pictureSelected = Picture.find(@selected_picture.keys)
    @specify_task = params[:tasks] || session[:tasks] || {}
    @specify_result = params[:results] || session[:results] || {}
    user_id = current_user.id
    @user_name = User.find(current_user.id).name
  end

  def reviewTask
    @selected_picture = session[:picture]
    @pictureSelected = Picture.find(@selected_picture.keys)
    @specify_task = params[:tasks] || session[:tasks]
    session[:tasks] = @specify_task
    @specify_result = params[:results] || session[:results]
    session[:results] = @specify_result
    user_id = current_user.id
    @user_name = User.find(current_user.id).name
  end
  
  def submit
    @selected_pictures = session[:picture] #hashTable: key is pic id, value is 1
    @taskTable = session[:tasks] #key is picture id, value is the task string
    @resultTable = session[:results] #key is picture id, value is the # of result the user wants
    redirect_to :controller => :mobilework, :action => :submit_task, :picTable => @selected_pictures, :taskTable => @taskTable, :resultTable => @resultTable
  end
end

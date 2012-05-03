require "net/http"
require "net/https"
require "rubygems"
require "json"
require 'open-uri'

class DashboardController < ApplicationController
  before_filter :authenticate_user!, :except => [:welcome]

  #replaced uploadToNew
  def uploadToAWS
    @len = session[:lenFinish]
    user_id = current_user.id
    #@user = current.user

    if request.post? #if the user clicked the "upload" button on the form
      if params[:album_name] == "" #a new album name is required
        flash.now[:error] = "Please enter a new album name before uploading a picture." #show error msg is new album name is empty

      #first find if user already has album with that name
      elsif Album.find_by_name(params[:album_name]).nil?
      #if Album.find_by_name_and_user_id(params[:albumName], user_id)==nil

        #start create new album,new picture, and upload the file.
        if params[:album_name] and not params[:album_id]
          album = Album.create!(:name => params[:album_name], :user_id => user_id)
        else
          album = Album.find_by_id(params[:album_id])
        end
        #actually uploading photo
        new_photo = Picture.uploadToAWS(params[:upload], album)
        
        #debugger
        
        redirect_to :action => "selectPhoto", :album_id => album.id

      else #if user already has album with same name
        flash[:error] = "You already have an album named #{params[:album_name]}, enter a new album name or add to the existing one!"
        redirect_to :action => "uploadToAWS"
      end
    end
  end

  def welcome
  end

  def index  #displaying facebook albums
    session.delete(:tasks)
    session.delete(:results)
    
    
    #check if theres stuff the user accepted
    if session[:acceptList] != [] and session[:acceptList]
      acceptPicID = session[:acceptList]  #a list of query ids
      
      acceptPicID.each do |id|
        #acceptPic = Query.find_by_id(id)
        #file = open("test.png", 'wb')
        #file << open(acceptPic.result_link).read
        #name = result.task_link
        #fakeUploadedFile = UploadedFile.new(:original_filename => name, :content_type => "image/jpeg", :tempfile => picFile)
        #debugger
        #Picture.uploadToAWS(file, "Result")
        Query.destroy(id)
      end
    end
 
    #check if there's stuff the user rejected
    if session[:rejectList] != [] and session[:rejectList]
      rejectPicID = session[:rejectList]
      #debugger
      rejectPicID.each do |id|
        Query.destroy(id)
      end
    end

  #---------------------check notification--------------------- Felix refactor the following------
    queryList = Query.find_all_by_user_id(current_user.id)
    pendingList = []
    finishedList = []
    queryList.each do |query|

      if query.result_link == ""
        #ask the api if the task is finished or not
        response = nil
        url = URI(query.task_link)
        http = Net::HTTP.new(url.host, 443)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        http.start do |http|
          req = Net::HTTP::Get.new(url.path)
          req.basic_auth("FelixXie","Phoenix1218118")
          response = http.request(req)
          #puts response.body
        end
        
        parsed_json = ActiveSupport::JSON.decode(response.body)

        #if answer = "sth" # finished, update Query table, add it to finishedlist
        if parsed_json["answer"] != ""
          finishedList << query.id #-----------------DEBUG------------------
          query.result_link = parsed_json["answer"]
          query.save
        else #task not finished on api
          pendingList << query.id #----------------DEBUG----------------
        end
      else #if result_link already exists in db
        #dont ask the api, just add it to finished list, and do the counting
        finishedList << query.id #------------------DEBUG----------------
      end
    end
    @len = finishedList.length
    session[:lenFinish] = finishedList.length

#-------------------------------------------------------------

    session[:finished_list] = finishedList #a list of query ids
    session[:pending_list] = pendingList #a list of query ids
#-------------------------------------------------check notification ends here------------


    if not session[:picture]
      session[:picture] = Hash.new
    end
    if params[:picture]       
      params[:picture].each do |key, value|
        session[:picture][key] = value
      end
    end
    @selected_picture = session[:picture]

    if not session[:picturefb]
      session[:picturefb] = Hash.new
    end  
    if params[:picturefb]
      params[:picturefb].each do |key, value|
        session[:picturefb][key] = value
      end
    end
    @selected_picturefb = session[:picturefb]

    
    # crowd albums part
    @crowdAlbums = User.find_by_id(current_user.id).albums

    # facebook albums part
    
    auth = Authorization.find_by_user_id(current_user.id)
    if auth
      token = auth.token
    end
    @user = current_user
    @user_name = current_user.name
    if token
      @albums = @user.grap_facebook_albums(token)
      #@albums = result
    else
      @albums = nil
    end
    @pictureSelected = Picture.find(@selected_picture.keys)
    @picturefbSelected = @selected_picturefb.keys
  end

  def showPhoto
    @len = session[:lenFinish]
    fb_album_id = params[:fb_album_id]
    token = Authorization.find_by_user_id(current_user.id).token
    albums = current_user.grap_facebook_albums(token)
    albums.each do |album|
      if album.identifier == fb_album_id
        @fb_pictures = album.photos
        @fb_album_name = album.name
      end
    end
  end

  def selectPhoto  #checkboxes page
    #album_id = params[:album_id]
    album = Album.find_by_id(params[:album_id])
    @album_name = album.name
    @pictures = album.pictures
    @len = session[:lenFinish]
  end


  def uploadPhotoToExisting     #upload photo to existing album
    @len = session[:lenFinish]
    user_id = current_user.id
    @user = User.find(user_id)

    if request.post? #if the user clicked the "upload" button on the form
      #start create new album,new picture, and upload the file.
      album_id = params[:album_id]

      #actually uploading photo
      namePathList = Picture.handleUpload(params[:upload], user_id)
      name = namePathList[0]
      path = namePathList[1]

      #create new picture tuple WARNING THIS MIGHT BE REDUNDANT CUZ OF ETHANS UPLOADTOAWS
      newPicture = Picture.create!(:name => name,:internal_link => path, :user_id => user_id, :album_id => album_id)

      redirect_to :action => "selectPhoto", :album_id => album_id

      #should reder somewhere at the end
    end
  end

  def selectAlbum
    @len = session[:lenFinish]
    user_id = current_user.id
    user = User.find(user_id)
    albumList = user.albums
    @lol = [] #@lol is [[al.name,al.id],[al.name,al.id]]
    albumList.each do |al|
      @lol << [al.name,al.id]
    end
  end

  def specifyTask
    
    @len = session[:lenFinish]
    if session[:picture] == {} and session[:picturefb] == {}
      flash[:error] = "Please Select Photo(s) Before Specifying Task(s)"
      redirect_to :action => :index
    end
    
    @selected_picture = session[:picture] || Hash.new
    #@selected_picturefb = session[:picturefb] || Hash.new
    if session[:picturefb]
      fb_user = current_user.fb_user 
      @selected_picturefb = Hash.new
      session[:picturefb].keys.each do |pid|
        @selected_picturefb[pid] = fb_picture_link(fb_user, pid)
      end
    else
      @selected_picturefb = Hash.new
    end
    @pictureSelected = Picture.find(@selected_picture.keys)
    #@picturefbSelected = @selected_picturefb.keys
    @picturefbSelected = @selected_picturefb
    @specify_task = session[:tasks] || Hash.new 
    @specify_result = session[:results] || Hash.new
    user_id = current_user.id
    @user_name = User.find(current_user.id).name
  end

  def reviewTask
     
    @len = session[:lenFinish]
    @selected_picture = session[:picture]
    #@selected_picturefb = session[:picturefb]
    if session[:picturefb]
      fb_user = current_user.fb_user
      @selected_picturefb = Hash.new
      session[:picturefb].keys.each do |pid|
        @selected_picturefb[pid] = fb_picture_link(fb_user, pid)
      end
    else
      @selected_picturefb = Hash.new
    end
    @pictureSelected = Picture.find(@selected_picture.keys)
    #@picturefbSelected = @selected_picturefb.keys
    @picturefbSelected = @selected_picturefb
    @specify_task = params[:tasks] || session[:tasks]
    session[:tasks] = @specify_task
    @specify_result = params[:results] || session[:results]
    session[:results] = @specify_result
    @user_name = User.find(current_user.id).name
  end

  def submit
    #@len = session[:lenFinish]
    #@selected_pictures = session[:picture] #hashTable: key is pic id, value is 1
    #@selected_picturesfb = session[:picturefb]
    #@taskTable = session[:tasks] #key is picture id, value is the task string
    #@resultTable = session[:results] #key is picture id, value is the # of result the user wants
    redirect_to :controller => :mobilework, :action => :submit_task
    #redirect_to :controller => :mobilework, :action => :submit_task, :picTable => @selected_pictures, :picfbTable => @selected_picturesfb, :taskTable => @taskTable, :resultTable => @resultTable
  end

  def getResult
    if params[:remaining_finished_list_after_accept]
      @finished_list = params[:remaining_finished_list_after_accept] 
      #debugger         
    elsif params[:remaining_finished_list_after_reject]
      @finished_list = params[:remaining_finished_list_after_reject]
    else #first time loading getResult page
      #session[:intermediate_finished_list] = session[:finished_list]  #only query ids
                                               #I need session[:intermediate_finished_list] because if the user doesn't accept/reject any pictures
      @finished_list = session[:finished_list]
      
      session[:acceptList] = [] #will only store the accepted query ids
      session[:rejectList] = []
      #debugger
    end
    #debugger
    @pending_list = session[:pending_list]
  end  
  
  def acceptResult
    accept_query_id = params[:accept_query].to_i #params[:accept_query] is a string
    #temp_finished_list = session[:intermediate_finished_list] #we remove sth from session[:intermediate_finished_list]
    temp_finished_list = session[:finished_list]
    temp_finished_list.delete(accept_query_id)
    session[:finished_list] = temp_finished_list #stores int
    remaining_finished_list = temp_finished_list #stores int
    #debugger
    #pending_list = session[:pending_list]
     
      
    temp_accept_list = session[:acceptList]
    temp_accept_list << accept_query_id
    session[:acceptList] = temp_accept_list #only contains list of accepted query ids
    
    redirect_to :action => :getResult, :remaining_finished_list_after_accept => remaining_finished_list and return
    #debugger 
  end
  
  def rejectResult
    reject_query_id = params[:reject_query].to_i
    #temp_finished_list = session[:intermediate_finished_list]
    temp_finished_list = session[:finished_list]
    temp_finished_list.delete(reject_query_id)
    session[:finished_list] = temp_finished_list
    remaining_finished_list = temp_finished_list
    #@pending_list = session[:pending_list]
    
    
    temp_reject_list = session[:rejectList]
    temp_reject_list << reject_query_id
    session[:rejectList] = temp_reject_list  #only cantains list of rejected query ids
    
    redirect_to :action => :getResult, :remaining_finished_list_after_reject => remaining_finished_list and return
    #debugger      
  end
  
  def fb_picture_link(fb_user, picture_id)
    albums = fb_user.albums
    albums.each do |album|
      album.photos.each do |photo|     
        if photo.identifier == picture_id
          return photo.source
        end
      end
    end
  end
  
end

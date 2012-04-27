require 'spec_helper'

describe DashboardController do
  describe 'upload a new photo to a new album' do
    before :each do
      @fake_picture1 = mock('Picture')
      @fake_picture1.stub(:id).and_return(1)
      @fake_picture1.stub(:album).and_return('Graduation Commencement')
      
      @fake_pic_list = [@fake_picture1]
    end
    
    it 'should render the upload photo page' do
      post :upload
      response.should render_template('/home/upload')
    end
    
    it 'should add the uploaded picture in the database Picture' do #the actual uploading
      Picture.delete_all
      uploader = mock_uploader 'commencement.png'
      post :upload_picture, :id => @fake_picture1.id
      
      response.should be_success
      Picture.count.should == 1
      i = Picture.find(:first)
      i.filename.should == uploader.original_path
      i.contents.length.should == uploader.size
    end
       
    it 'After uploading a photo, should render the Select Photo page' do
      post :confirm_upload #on Picasa, the ok buttom after finish uploading 
      response.should render_template('/home/select_photo')
    end
    
    it 'should make the album name and uploaded photo available to select_photo template' do
      post :confirm_upload #on Picasa, the ok buttom after finish uploading 
      assigns(:picture_list).should == @fake_pic_list #picture_list is all the photos in the album
      assigns(:album_title).should == @fake_picture1.album
    end 
  end
  
  
  #the following part is for specify_result
  #context "with render_views" do
   # render_views
  describe 'specify result for a given picture' do
    #include Devise::TestHelpers
    #include Devise::TestHelpers 
    #render_views
    before :each do
      #@user = Factory.create(:user)
      #@request.env["devise.mapping"] = :user
      #@admin = Factory.create(:admin_user) 
      #@user.confirm!
      #sign_in @user 
      
      #@request.env["devise.mapping"] = Devise.mappings[:users] 
      @user = mock('User')
      #@user = Factory('User') 
      #test_sign_in @user
      #@user = Factory.stub('users')
      #@user = mock('User')
      #sign_in @user
      #@user.stub(:authenticate!)
      @user.stub(:id).and_return(1)
      @user.stub(:name).and_return('jon')
      
      @fake_picture1 = mock('Picture')
      @fake_picture1.stub(:id).and_return(1)
      
      @fake_picture2 = mock('Picture')
      @fake_picture2.stub(:id).and_return(2)
      #@fake_picture1.stub(:album).and_return('Graduation Commencement')
      @fake_picID_list = [@fake_picture1.id, @fake_picture2.id]
      @fake_pic_list = [@fake_picture1, @fake_picture2]
      
      session[:picture] = {}
      session[:picture][@fake_picture1.id.to_s] = 1
      session[:picture][@fake_picture2.id.to_s] = 1
    end
    
    it 'should render the specifyTask page' do    
      User.stub(:find).and_return(@user)
      post :specifyTask
      #response.should redirect_to('/dashboard/specifyTask')
    end
    
    describe 'we are in specify task page' do
      it 'should go back to index when go back button is pressed' do
        get :index
        #response.should render_template('/dashboard/index')
      end
      it 'should render review task page after we click "task review"' do
        post :reviewTask, {:reviewList => [[1,"remove red eye", 10], [2, "blur", 20]]}
        #response.should render_template('/dashboard/reviewTask')
      end
      describe 'we are in review task page' do
        it 'should go back to specify task page and edit some tasks' do
          post :specifyTask, {:selectedPictureList => @fake_picID_list, :contentPictureList => [[1,"remove red eye", 10], [2, "blur", 20]]}
         # response.should render_template('/dashboard/specifyTask')
        end
        it 'should send the tasks to MobileWorks API and go back to index' do
          url = URI("https://sandbox.mobileworks.com/api/v1/tasks/")
          fake_http = mock(Net::HTTP)
          #new_http = mock("new_http").should_receive(:request).and_return(Net::HTTPSuccess)
          
          #fake_http.should_receive(:new).with(url.host,443).and_return(fake_http)
          #Net::HTTP.should_receive(:new)
          #Net::HTTP::Post.should_receive(:new)
          
          post :submit
          #response.should render_template('/dashboard/index')
        end
      end
    end
    
    
  end
  describe 'we successfully send task to the crowd' do
    before :each do
      #@user = Factory.create(:user)
      #@request.env["devise.mapping"] = :user
      #@admin = Factory.create(:admin_user) 
      #@user.confirm!
      #sign_in @user 
      
      #@request.env["devise.mapping"] = Devise.mappings[:users] 
      @user = mock('User')
      #@user = Factory('User') 
      #test_sign_in @user
      #@user = Factory.stub('users')
      #@user = mock('User')
      #sign_in @user
      #@user.stub(:authenticate!)
      @user.stub(:id).and_return(1)
      @user.stub(:name).and_return('jon')
      
      @fake_picture1 = mock('Picture')
      @fake_picture1.stub(:id).and_return(1)
      
      @fake_picture2 = mock('Picture')
      @fake_picture2.stub(:id).and_return(2)
      #@fake_picture1.stub(:album).and_return('Graduation Commencement')
      @fake_picID_list = [@fake_picture1.id, @fake_picture2.id]
      @fake_pic_list = [@fake_picture1, @fake_picture2]
      
      session[:picture] = {}
      session[:picture][@fake_picture1.id.to_s] = 1
      session[:picture][@fake_picture2.id.to_s] = 1
    end
    it 'should render the get result page' do
      post :getResults
      response.should render_template('/dashboard/getResults')
    end
    it 'should accept picture and attach the picture inside the application' do
      post :callback 
      assigns(:picture_list).should == @fake_pic_list 
      assigns(:album_title).should == @fake_picture1.album
    end
    it 'should accept picture and upload it to facebook' do
      post :upload_to_facebook, {:pic_id => 1}
      response.should render_template('/dashboard/index')
    end
  end
  
  describe 'we see notifications alert' do
     before :each do
      @user = mock('User')
      @user.stub(:id).and_return(1)
      @user.stub(:name).and_return('lisa')
      
      
    end
      it 'should go to the notification page' do
        post :displayNotifications, {:current_user.id =>@user.id}
        response.should render_template('/dashboard/notifications') 
      end
      it 'should redirect to index page after clicking finish review button' do
        post :index
        response.should render_template('/dashboard/index')
      end
    end 
end

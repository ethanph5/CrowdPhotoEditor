require 'spec_helper'

describe DashboardController do

  describe 'select the existing photo' do
    before :each do
      @fake_results = [mock('Home'), mock('Home')]
    end
    it 'should call the facebook api to retrieve album photo from facebook' do
      get '/api/facebook/photo'
      response.body.should == 'https://api.facebook.com/method/users.getInfo?uids=4&fields=name&access_token=...'
    end
    describe 'after that we see the album photo' do
      it 'should pick the photo for certain id' do
        post :pick_photo, {:id => 1}
      end
      it 'should choose continue button' do
        Home.should_receive(:proceed).and_return(true)
        post :continue, {:id => 1}
      end
      it 'should select the dashboard template for rendering' do
        post :continue, {:id => 1}
        response.should render_template('/home/dashboard')       
      end
    end
  end
  describe 'Upload a new photo and add to an existing album' do
    before :each do
      @fake_results = [mock('Home'), mock('Home')] 
    end
    it 'should render the upload photo page' do
      post :upload
      response.should render_template('/home/upload')
    end
    it 'should select an album and a photo' do
      Home.should_receive(:pick_photo).and_return(@fake_results)
      post :pick_photo, {:id => 1}
    end
    it 'should render the dashboard page' do
      response.should render_template('/home/dashboard')
    end
    it 'should call select method to select a photo' do
      Home.should_receive(:pick_photo).and_return(@fake_results)
      post :pick_photo, {:id => 1}
      assigns(:home).should == @fake_results
    end
  end
  
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
  describe 'specify result for a given picture' do
    before :each do
      @fake_picture1 = mock('Picture')
      @fake_picture1.stub(:id).and_return(1)
      
      @fake_picture2 = mock('Picture')
      @fake_picture2.stub(:id).and_return(2)
      #@fake_picture1.stub(:album).and_return('Graduation Commencement')
      @fake_picID_list = [@fake_picture1.id, @fake_picture2.id]
      @fake_pic_list = [@fake_picture1, @fake_picture2]
    end
    
    it 'should render the specifyTask page' do
      post :specifyTask, {:selectedPictureList => @fake_picID_list, :contentPictureList => []}  #pass list of ID as argument
      response.should render_template('/dashboard/specifyTask')
    end
    
    describe 'we are in specify task page' do
      it 'should go back to index when go back button is pressed' do
        get :index
        response.should render_template('/dashboard/index')
      end
      it 'should render review task page after we click "task review"' do
        post :reviewTask, {:reviewList => [[1,"remove red eye", 10], [2, "blur", 20]]}
        response.should render_template('/dashboard/reviewTask')
      end
      describe 'we are in review task page' do
        it 'should go back to specify task page and edit some tasks' do
          post :specifyTask, {:selectedPictureList => @fake_picID_list, :contentPictureList => [[1,"remove red eye", 10], [2, "blur", 20]]}
          response.should render_template('/dashboard/specifyTask')
        end
        it 'should send information to MobileWorks API and go back to index' do
          to be continued....
        end
      end
    end 
  end
  
end
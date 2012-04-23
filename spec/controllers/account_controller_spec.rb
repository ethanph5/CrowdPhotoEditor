=begin
require 'spec_helper'
describe AccountController do
  
  before :each do
      @lisa =mock('User')
      @lisa.stub(:id).and_return('1')
      @lisa.stub(:name).and_return('Lisa')
      @lisa.stub(:email).and_return('lisa@gmail.com')
      @lisa.stub(:password).and_return('111111')
      @lisa.stub(:credit).and_return('100')
      #@lisa=FactoryGirl.create(:user, :name =>'Lisa', :email =>'sth@gmail.com', :password =>'123', :credit =>'100')
      #@liz=FactoryGirl.create(:user,:name =>'liz', :email=>'liz@gmail.com',:password => '111',:credit =>'100')
    end
  
  describe "user can login" do
    it "should login the user with the right login info successfully" do
      #visit '/'
      #fill_in :email, :with => @lisa.email
      #fill_in :password, :with => @lisa.password
      #click_button "Log In"
      User.should_receive(:find).with(:first, :conditions =>['email=?','lisa@gmail.com']).and_return(@lisa)
      
      post 'login', :email => 'lisa@gmail.com', :password => '123'
      response.should redirect_to(:controller => 'dashboard',:action => 'index')
      #request.session[:user_id].should == @lisa.id
    end
  end
  
  describe 'Login with nil user and password' do
    before(:each) do
      User.stub!(:count).and_return(1)
    end

    def make_request
      post 'login', :email => "", :password => ""
    end

    it 'should render login action' do
      make_request
      #response.should render_template()
      response.should redirect_to(:action => :welcome)
    end
  end

  
  describe 'first time user sign up user account' do
    
    it "redirects to the created user account/dashboard index page" do
      User.stub(:new).and_return(@lisa)
      @lisa.stub(:save).and_return(true)
      #request.session[:user_id].should == @lisa.id
      post 'signup'
      
      response.should redirect_to(:controller => 'dashboard',:action => 'index')
    end
  end
  
  
end
=end
  
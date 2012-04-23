require 'spec_helper'

describe AuthorizationController do
  include Devise::TestHelpers
  
  before (:each) do
    request.env["devise.mapping"] = Devise.mappings[:user] 
    request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
    @lisa = Factory.create(:user)
    sign_in @lisa
  end
  
  it 'should have a current_user' do 
    subject.current_user.should_not be_nil
    subject.current_user.name.should == "lisa"
    
  end
  
  #it 'should successfully sign in and redirected to user account' do
    
  #end
  
  #describe 'first time user sign up user account' do
    
   # it "redirects to the created user account/dashboard index page" do
    #  User.stub(:new).and_return(@lisa)
     # @lisa.stub(:save).and_return(true)
      #request.session[:user_id].should == @lisa.id
      #post '/'
      
      #response.should be_redirect
    #end
 # end
  
  #describe "authrization create" do
    #before (:each)do
      #request.env["devise.mapping"] = Devise.mappings[:user] 
     # request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
    #  @fake_Auth=mock('Authorization')
   #   @fake_Auth.stub(:provider).and_return('facebook')
      #@fake_Auth.stub(:uid).and_return('1234567890')
      ##@lisa = Factory.create(:user)
     # sign_in @lisa
    #end
    
    #it 'should add service to users authorization table' do
      #post :controller => "authorizations", :action => "create"
     # Authorization.should_receive(:find_by_provider_and_uid).with(:provider => 'facebook', :uid => '1234567890').and_return(@fake_Auth)
    #  response.should redirect_to authorizations_path
   # end
    
  #end
  

    
end
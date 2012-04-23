require 'spec_helper'

describe AuthorizationController do
  #include Devise::TestHelpers
  
  before (:each)do
    request.env["devise.mapping"] = Devise.mappings[:user] 
    request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook] 
  end
  
  it 'should allow login' do 
    controller.stub!(:auth_hash).and_return({:provider => "facebook", :info => {:name => "lisa", :email => 'lol@gmail.com'}, :uid => '123456790'}) 
    get :create, :provider => 'facebook' 
    assigns(:user).should_not be_nil 
  end  
    
end

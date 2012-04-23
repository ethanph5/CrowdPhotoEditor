require 'spec_helper'

describe AuthorizationController do
  #include Devise::TestHelpers
  
  before (:each)do
    request.env["devise.mapping"] = Devise.mappings[:user] 
    request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
    @lisa = FactoryGirl.create(:user)
    sign_in @lisa
  end
  
  it 'should have a current_user' do 
    
    subject.current_user.should_not be_nil
  end
  

    
end
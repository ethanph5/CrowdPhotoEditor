require 'spec_helper'

describe AccountController do
  
  describe 'first time user sign up user account' do
    before :each do
      @lisa=Factory(:user, :name =>'Lisa', :email =>'sth@gmail.com', :password =>'123', :credit =>'100')
      @liz=Factory(:user,:name =>'liz', :email=>'liz@gmail.com',:password => '111',:credit =>'100')
    end
    it 'user successfully log in and session gets a user' do
      post 
    end
  end


end
  
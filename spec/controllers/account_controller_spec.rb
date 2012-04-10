require 'spec_helper'

describe AccountController do

  describe "GET 'signin'" do
    it "returns http success" do
      get 'signin'
      response.should be_success
    end
  end
  
  describe "user signin" do
    it "display the user's username after successful login" do
      user = User.create!(:name => "lisa", :password => "secret")
      get "/signin"   
      assert_select "form.signin" do
        assert_select "input[name=?]", "name"
        assert_select "input[name=?]", "password"
        assert_select "input[name=?]", "submit"
      end
      post "/signin", :name => "lisa", :password =>"secret"
      assert_select ".header .name", :text => "lisa"
    end
  end

  describe "invalid signin" do
      it "should not sign a user in" do
        

      it "should not create a user" do
        lambda do
          post :create, :user => @attr
        end.should_not change(User, :count)
      end

      it "should render the 'signin' page" do
        post :create, :user => @attr
        response.should render_template('account/signin')
      end
    end
    
    describe "with valid email and password" do

      before(:each) do
        @attr = { :name => "New User", :email => "user@example.com",
                  :password => "foobar", :password_confirmation => "foobar" }
      end

      it "should create a user" do
        lambda do
          post :create, :user => @attr
        end.should change(User, :count).by(1)
      end

      it "should sign the user in and redirect to the user homepage" do
        post :create, :user => @attr
        response.should redirect_to(user_path(assigns(:user)))
      end    
    end
  end

end
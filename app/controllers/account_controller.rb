#require 'omniauth'

class AccountController < ApplicationController
  
  def welcome
    if session[:user_id] or session[:token]
      flash[:notice] = "You are already log in, please log out first."
      redirect_to :controller => :dashboard, :action => :index
    end
  end
  
  def signup
    #Attempts to create a new user
    if session[:user_id] or session[:token]
      flash[:notice] = "You are already log in, please log out first."
      redirect_to :controller => :dashboard, :action => :index
    end
    
    if params[:password] == params[:password_confirm]
      user = User.new do |u| 
        u.name = params[:username]
        u.password = params[:password]
        u.credit = 100
        u.email = params[:email]
      end
    else
      flash[:notice] = "Password need to be matched."
      redirect_to :action => "signup" and return
    end
    
    if session[:auth_hash]
      @username = session[:auth_hash][:info][:name]
      @email = session[:auth_hash][:info][:email]
      @auth = true
    end
      #creates a new instance of the user model
     
    
    if request.post? #checks if the user clicked the "submit" button on the form
      if user.save #if they have submitted the form attempts to save the user      
        if session[:auth_hash]
          #auth_hash = {:token => params[:token], :provider => params[:provider], :uid => params[:uid]}
          #auth_hash = request.env['omniauth.auth']
          auth = Authorization.find_or_create(user, session[:auth_hash])
          session[:token] = auth.token        
        end
        session[:user_id] = user.id #Logs in the new user automatically
        session[:auth_hash] = nil
        redirect_to :controller => :dashboard, :action => :index
      else #This will happen if one of the validations define in /app/models/user.rb fail for this instance.
        flash[:notice] = user.errors.full_messages #Return the error message from validation check
        redirect_to :action => :signup #Ask them to sign up again
      end
    end
  end

  def login
    if request.post? #If the form was submitted
      user = User.find(:first, :conditions=>['email=?',(params[:email])]) #Find the user based on the name submitted
      if !user.nil? && user.password==params[:password] #Check that this user exists and it's password matches the inputted password
        session[:user_id] = user.id #If so log in the user
        auth = Authorization.where("user_id = ? AND provider = ?", user.id, 'facebook').first
        #auth = Authorization.find_by_user_id(user.id)
        if not auth.nil?
          session[:token] = auth.token
        end
        
        redirect_to :controller => "dashboard", :action => "index" #And redirect to their calendars
      else
        flash[:error] = "Invalid email or password."
        redirect_to :action => "welcome",  #Otherwise ask them to try again. 
      end
    end
  end
  
  def create
    #auth_hash = request.env['omniauth.auth']
    auth_hash
    if session[:user_id] and not session[:token]
      # Means our user is signed in. Add the authorization to the user
      #User.find(session[:user_id]).add_provider(auth_hash)
      redirect_to :controller => :dashboard, :action => :index
      #render :text => "You can now login using #{auth_hash["provider"].capitalize} too!"
    elsif session[:token]
      flash[:notice] = "You are already log in, please log out first."
      redirect_to :controller => :dashboard, :action => :index
    else
      # Log him in or sign him up
      #auth = Authorization.find_or_create(auth_hash)
      #session[:token] = auth_hash['credentials']['token']
      #session[:user_id] = auth.user_id
      # Create the session
      #render :text => auth_hash["info"]["email"]
      
      #redirect_to :action => :signup, :username => auth_hash["info"]["name"], :email => auth_hash["info"]["email"], 
                  #:provider => auth_hash["provider"], :uid => auth_hash["uid"], :token => auth_hash['credentials']['token']
      session[:auth_hash] = auth_hash
      redirect_to :action => :signup
    end
  end
  
  
  
  
  def logout
    session[:user_id] = nil
    token = session[:token]
    session[:token] = nil
    if token
      redirect_to   "https://www.facebook.com/logout.php?access_token=" + token + "&next=http://localhost:3000"
    else
      redirect_to :action => 'welcome'
    end
  end
  
  protected
  def auth_hash
    request.env['omniauth.auth']
  end
end

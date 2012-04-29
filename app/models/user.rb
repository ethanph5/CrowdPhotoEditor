class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me, :credit
  
  validates_presence_of :name, :email
  validates_uniqueness_of :email, :case_sensitive => false
  
  has_many :authorizations, :dependent => :destroy
  has_many :pictures, :dependent => :destroy
  has_many :albums, :dependent => :destroy
  has_many :queries, :dependent => :destroy
  
  def grap_facebook_albums(token)
    facebook = authorizations.where(:provider => :facebook).first
    user = ::FbGraph::User.fetch(facebook.uid, :access_token => token)
    #user = user.fetch
    user.albums
    #user.permissions
    #fb_token
    #fb_albums = fb_user.albums
  end
end

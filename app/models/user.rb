class User < ActiveRecord::Base
  validates :name, :password, :presence => true
  validates :email, :presence => true, :uniqueness => true, :format => { :with => /.*@.*\..*/,
    :message => "format incorrect." } #DEBUG: email reusing is not allowed?
  
  has_many :authorizations
  has_many :pictures
  has_many :albums
  #has_and_belongs_to_many :facebook_accounts  #DEBUG: facebookAccounts or facebook_accounts??

  def add_provider(auth_hash)
  # Check if the provider already exists, so we don't add it twice
    unless authorizations.find_by_provider_and_uid(auth_hash["provider"], auth_hash["uid"])
      Authorization.create :user => self, :provider => auth_hash["provider"], :uid => auth_hash["uid"]
    end
  end
  
  def grap_facebook_albums(fb_token)
    #user = FbGraph::User.me(fb_token)
    #user = FbGraph::User.fetch(username)
    #user.name
    #user.albums
    facebook = authorizations.where(:provider => :facebook).first
    #fb_user = ::FbGraph::User.fetch facebook.uid, :access_token => facebook.token
    #fb_user = ::FbGraph::User.fetch(facebook.uid, :access_token => fb_token)
    #fb_user = ::FbGraph::Album.fetch facebook.uid, :access_token => fb_token
    user = ::FbGraph::User.fetch(facebook.uid, :access_token => fb_token)
    #user = user.fetch
    user.albums
    #user.permissions
    #fb_token
    #fb_albums = fb_user.albums
  end
  
end

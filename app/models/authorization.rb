class Authorization < ActiveRecord::Base
  belongs_to :user
  validates :provider, :uid, :presence => true
  
  def self.find_or_create(user, auth_hash)
    unless auth = find_by_provider_and_uid(auth_hash[:provider], auth_hash[:uid])
      #user = User.create :name => auth_hash["info"]["name"], :email => auth_hash["info"]["email"], :password => 123
      #auth = create :user => user, :provider => auth_hash["provider"], :uid => auth_hash["uid"], :token => auth_hash['credentials']['token']
      auth = Authorization.create :user => user, :provider => auth_hash[:provider], :uid => auth_hash[:uid], :token => auth_hash[:token] 
    end
    debugger
    auth
  end
end

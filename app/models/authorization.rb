class Authorization < ActiveRecord::Base
  belongs_to :user
  attr_accessible :provider, :uid, :token
  validates :provider, :uid, :token, :presence => true
end

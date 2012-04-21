class Album < ActiveRecord::Base
  validates :name, :presence => true #Makes sure all albums have a name.
  validates_uniqueness_of :user_id, :scope => :name #Within the scope of a single user, album names are unique
  
  has_many :pictures
  belongs_to :user
end

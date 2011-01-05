class User < ActiveRecord::Base
	has_and_belongs_to_many :affiliations
	has_and_belongs_to_many :works
	validates :handle, :presence => true, :uniqueness => true
	validates :email, :presence => true, :uniqueness => true
	validates :showname, :presence => true
	validates :showemail, :presence => true
	validates :notify, :presence => true
	validates :passhash, :presence => true
end

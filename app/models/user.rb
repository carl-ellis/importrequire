class User < ActiveRecord::Base
	has_and_belongs_to_many :affiliations
	has_and_belongs_to_many :tags
	has_and_belongs_to_many :works
  has_many :ratings
  has_many :messages, :foreign_key => "to_id"
	validates :handle, :presence => true, :uniqueness => true
	validates :email, :presence => true, :uniqueness => true
	validates :passhash, :presence => true
end

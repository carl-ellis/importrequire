class Work < ActiveRecord::Base
	has_and_belongs_to_many :users
	has_and_belongs_to_many :tags
	validates :name, :presence => true
	validates :description, :presence => true
	validates :url, :presence => true
end

class Tag < ActiveRecord::Base
	has_and_belongs_to_many :users
	has_and_belongs_to_many :works
	validates :name, :presence => true

end

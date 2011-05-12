class Rating < ActiveRecord::Base
  has_one :user
  has_one :work
end

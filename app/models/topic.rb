class Topic < ActiveRecord::Base
	has_many :user_topic
  	has_many :user, :through => :user_topic
end

class User < ActiveRecord::Base
	has_many :user_topic
  	has_many :topic, :through => :user_topic
    geocoded_by latitude: :latitude, longitude: :longitude
	reverse_geocoded_by :latitude, :longitude
	 validates_uniqueness_of  :username
	 def gmaps4rails_title
      self.topic.pluck(:name).join(", ").titleize
    end

    def same_topic_user
    	User.near(self, 10000, :order => 'distance').joins(:topic).where.not(:id => self.id).uniq.to_a
    end

    def meetup
        meetup_api = MeetupApi.new
        location = Geocoder.search("#{user.latitude}, #{user.longitude}").first
        topics = user.topic
        topics.each do |topic|
            unless topic.meetup_category_id.nil?
                params = { 
                    category: "#{topic.meetup_category_id}",
                    city: "#{location.city}",
                    country: "#{location.country_code}",
                    status: 'upcoming',
                    format: 'json',
                    page: '1'
                }
                events = meetup_api.open_events(params)
                events.inspect
            end
        end
    end

    def user_friendly_distance(user)
    	distance = self.distance_from(user)
    	if distance <= 1
    		user_friendly_distance = "~ 1km"
    	elsif distance <= 5
    		user_friendly_distance = "~ 5km"
    	elsif distance <= 10
    		user_friendly_distance = "~ 10km"
    	elsif distance <= 20
    		user_friendly_distance = "~ 20km"
    	elsif distance <= 50
    		user_friendly_distance = "~ 50km"
        elsif distance <= 100
            user_friendly_distance = "~ 100km"
        elsif distance <= 500
            user_friendly_distance = "~ 500km"
        elsif distance <= 1000
            user_friendly_distance = "~ 1000km"
        elsif distance <= 5000
            user_friendly_distance = "~ 5000km"
        elsif distance <= 10000
            user_friendly_distance = "~ 10000km"
    	else
    		user_friendly_distance = "#{distance} km"
    	end
    end
end

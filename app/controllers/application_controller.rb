class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :find_user
  before_filter :populate_topic
  before_filter :populate_user
  	def find_user
  		if cookies["poi_user"]
  			@user = User.find(cookies["poi_user"].to_i)
  		end
  	end

  	def populate_user
  		if User.all.size == 0
	  		address_array = ["16 rue montmartre Paris","10 place des victoires Paris","267 rue st honoré Paris","47 rue de saintonge Paris","49-51 rue vieille du temple Paris","24 rue saint sulpice Paris","15 rue de sèvres Paris","42 rue du four Paris","29 rue boissy d'anglas Paris","2 rue scribe Paris","81 rue du faubourg saint antoine Paris","16 rue du commerce Paris","26 avenue victor hugo Paris","30 rue de passy Paris","143 rue de la pompe Paris","106 rue de courcelles Paris","20 avenue des ternes Paris", "92 rue des martyrs Paris"]
			topics = Topic.all.pluck(:id)
			address_array.each do |address| 
				location = Geocoder.search(address).first
				user = User.create(:username => Faker::Internet.user_name.capitalize, :longitude => location.longitude, :latitude => location.latitude)
				topic_array = topics.sample(3)
				topic_array.each do |topic_id|
					UserTopic.create(:user => user, :topic_id => topic_id)
				end
			end	  		
  		end		
  	end

  	def populate_topic
  		if Topic.all.size == 0
  			array = Array.new
			Dir.glob("app/assets/images/topics/*.png").each do |file_url|
				topic_name = file_url.gsub("app/assets/images/topics/", "")
				Topic.create(:name =>topic_name.gsub(".png", ""))
			end
  		end
  	end
end

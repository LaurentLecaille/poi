class ApiController < ApplicationController

	def get_user
		address = Geocoder.search("#{params["lt"]}, #{params["lg"]}")
		user = User.create(:username => params["username"], :longitude => params["lg"], :latitude => params["lt"])
		topics_array = params["topic_id"].split(",")
		topics_array.each do |topic_id|
			UserTopic.create(:user => user, :topic_id => topic_id)
		end
		render :json => {"formatted_address" => address.first.formatted_address, "user_id" =>user.id}.to_json
	end
end

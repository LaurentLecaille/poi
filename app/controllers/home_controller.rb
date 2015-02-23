class HomeController < ApplicationController

	def index
		@topics = Topic.all
		@hash = Gmaps4rails.build_markers(@users) do |user, marker|
			marker.lat user.latitude
			marker.lng user.longitude
			marker.infowindow "#{user.username} - #{user.gmaps4rails_title}"
		end
		if @user.nil?
			@user_list = User.all
		else
			@user_list = @user.same_topic_user
		end
		@markers = @hash.to_json;
	end

	def topic_user_list
		if params["topic_id"] && @user
			user_list =  Topic.find(params["topic_id"]).user.near(@user, 10000, :order => 'distance').to_a
		elsif params["topic_id"] && @user.nil?
			user_list =  Topic.find(params["topic_id"]).user
		else
			user_list = @user.same_topic_user
		end
		@topics = Topic.all
		render "layouts/_list", 
         locals: { user_list: user_list, topics:Topic.all},
         layout: false
	end

	def set_map
		if params["topic_id"].nil? && @user.nil?
			user_list =  User.all.to_a

		elsif params["topic_id"]
			user_list =  Topic.find(params["topic_id"]).user.to_a
		else
			user_list = @user.same_topic_user
		end
		hash = Gmaps4rails.build_markers(user_list) do |user, marker|
  			marker.lat user.latitude
  			marker.lng user.longitude
			marker.infowindow "#{user.username} - #{user.gmaps4rails_title}"

		end
		render :json => hash
	end
end

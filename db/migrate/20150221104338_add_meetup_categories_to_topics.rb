class AddMeetupCategoriesToTopics < ActiveRecord::Migration
  def change
  	add_column :topics, :meetup_category_id, :integer  
  end
end

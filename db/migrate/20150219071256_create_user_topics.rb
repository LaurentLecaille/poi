class CreateUserTopics < ActiveRecord::Migration
  def change
    create_table :user_topics do |t|
      t.references :user
      t.references :topic

      t.timestamps null: false
    end
  end
end

class AddEtsyUserIdToItems < ActiveRecord::Migration
  def change
  	add_column :items, :etsy_user_id, :integer
  end
end

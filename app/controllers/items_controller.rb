class ItemsController < ApplicationController

	def show
		@item = Item.find(params[:id])
		get_item_images(@item.etsy_id)
		get_user_avatar(@item.etsy_user_id)
		get_user_details(@item.etsy_user_id)
	end

	def new
		@item = Item.new
	end

	def create
		@item = Item.new(item_params)
		if @item.save
			redirect_to wishlist_path(params[:wishlist_id]), notice: "Item added."
		else
			redirect_to :back, alert: "Failed to save."
		end
	end

	private

	def item_params
		params.require(:item).permit!
	end
end

class ItemsController < ApplicationController

	def show
		@item = Item.find(params[:id])
		
		response = HTTParty.get("https://openapi.etsy.com/v2/listings/#{@item.etsy_id}/images?api_key=#{Rails.application.secrets.etsy_api_key}")
		@images = response["results"]
		
		etsy_user_avatar_hash = HTTParty.get("https://openapi.etsy.com/v2/users/#{@item.etsy_user_id}/avatar/src?api_key=#{Rails.application.secrets.etsy_api_key}")
		@etsy_user_avatar = etsy_user_avatar_hash["results"]["src"]

		etsy_user_hash = HTTParty.get("https://openapi.etsy.com/v2/users/#{@item.etsy_user_id}/profile?api_key=#{Rails.application.secrets.etsy_api_key}")
		@etsy_shop_name = etsy_user_hash["results"][0]["login_name"]
		@etsy_seller_first_name = etsy_user_hash["results"][0]["first_name"]
		@etsy_seller_last_name = etsy_user_hash["results"][0]["last_name"]

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

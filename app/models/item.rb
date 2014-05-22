class Item < ActiveRecord::Base
	belongs_to :wishlist

	before_create :get_etsy_id, :set_attributes_from_etsy

	def get_etsy_id
		string = self.etsy_url
		regex = /\d+/
		numbers = string.scan(regex)
		self[:etsy_id] = numbers[0]
	end

	def set_attributes_from_etsy
		etsy_data = get_etsy_data
		puts etsy_data
		listing = etsy_data["results"][0]
		self[:name] = listing["title"]
		self[:description] = listing["description"]
		self[:etsy_user_id] = listing["user_id"]
	end

	def get_etsy_data
		response = HTTParty.get("https://openapi.etsy.com/v2/listings/#{self.etsy_id}?api_key=#{Rails.application.secrets.etsy_api_key}")
	end

end

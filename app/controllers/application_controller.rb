class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :ensure_logged_in

  helper_method :current_user

  def get_user_avatar(etsy_user_id)
    etsy_user_avatar_hash = HTTParty.get("https://openapi.etsy.com/v2/users/#{etsy_user_id}/avatar/src?api_key=#{Rails.application.secrets.etsy_api_key}")
    @etsy_user_avatar = etsy_user_avatar_hash["results"]["src"]
  end

  def get_user_details(etsy_user_id)
    etsy_user_hash = HTTParty.get("https://openapi.etsy.com/v2/users/#{etsy_user_id}/profile?api_key=#{Rails.application.secrets.etsy_api_key}")
    user_hash_header = etsy_user_hash["results"][0]
    @etsy_shop_name = user_hash_header["login_name"]
    @etsy_seller_first_name = user_hash_header["first_name"]
    @etsy_seller_last_name = user_hash_header["last_name"]
  end

  def get_item_images(etsy_id)
    response = HTTParty.get("https://openapi.etsy.com/v2/listings/#{etsy_id}/images?api_key=#{Rails.application.secrets.etsy_api_key}")
    @images = response["results"]
  end

  def ensure_logged_in
  	if current_user.nil?
  		redirect_to login_path
  	end
  end

  private

  def current_user
  	@current_user ||= User.find(session[:user_id]) if session[:user_id]
  end



end

class PreferencesController < ApplicationController
	before_action :authenticate_user!


	def new
	end

	def create
	end

	private

	def user_params
		params.require(:user).permit( 
			massage_attributes: [:id, :address, :title, :rating, :rating_count,
				:fine_print, :merchant_profile]
		)
	end
end



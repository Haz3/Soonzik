class OthersController < ApplicationController
  include FormatsHelper
	before_action :no_content

	def no_content
		render :text => "", :layout => true
	end

	def index
	end

	def search
	end

	def explorer
	end

	def discotheque
		if (!user_sign_in?)
			redirect_to :root
		end
	end
end
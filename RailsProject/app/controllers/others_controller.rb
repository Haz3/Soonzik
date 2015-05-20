class OthersController < ApplicationController
  include FormatsHelper
	before_action :no_content

	def no_content
		render :text => "", :layout => true
	end
end
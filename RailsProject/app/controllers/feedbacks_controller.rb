class FeedbacksController < ApplicationController
	before_action :setSubject

	def new
		@feedback = Feedback.new
	end

	def create
		@feedback = Feedback.new Feedback.feedback_params(params)
		@feedback.user_id = current_user.id if user_signed_in?
		if (@selectedObject.include?@feedback.type_object && @feedback.save)
			flash[:notice] = "Your feedback has been saved. We will contact you by email if it's necessary"
			redirect_to :root
		else
			render :action => 'new'
		end
	end

	def setSubject
		@selectedObject = [
			["Bug on the website", "bug"],
			["Payment issue", "payment"],
			["Account issue", "account"],
			["Other", "other"]
		]
	end
end

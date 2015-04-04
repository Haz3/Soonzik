module ApplicationHelper

	def socialImgConnect(provider)
 		case provider
   			when "Facebook"
     			return "step fi-social-facebook size-72"
   			when "Twitter"
   				return "step fi-social-twitter size-72"
   			when "Google"
   				return "step fi-social-google-plus size-72"
 		end
	end
end

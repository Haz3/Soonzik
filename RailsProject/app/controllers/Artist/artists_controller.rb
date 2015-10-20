# The module contain every class from the Artist panel
# It is used for the routing (for the subdomain)
module Artist
  # The class is the parent of every class
  class ArtistsController < ApplicationController
  	layout 'artist'

    before_action :cors_set_access_control_headers
    before_filter :authenticate_user!
    before_action :cookieMe

    # For all responses in this controller, return the CORS access control headers.
    def cors_set_access_control_headers
      if !user_signed_in? || user_signed_in? && !current_user.isArtist?
        redirect_to root_url subdomain: false
      end

      headers['Access-Control-Allow-Origin'] = '*'
      headers['Access-Control-Expose-Headers'] = 'ETag'
      headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
      headers['Access-Control-Allow-Headers'] = '*,x-requested-with,Content-Type,If-Modified-Since,If-None-Match,Auth-User-Token'
      headers['Access-Control-Allow-Credentials'] = 'true'
      headers['Access-Control-Max-Age'] = "1728000"
    end

    # If the user is logged, we put some information into the cookies to allow Ajax call
    def cookieMe
      if user_signed_in?
        cookies[:user_id] = current_user.id
        cookies[:user_token] = current_user.salt
        cookies[:user_username] = current_user.username
      elsif !user_signed_in?() && cookies.has_key?(:user)
        cookies.delete :user
      end
    end
  end
end
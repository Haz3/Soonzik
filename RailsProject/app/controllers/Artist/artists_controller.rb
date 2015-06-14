# The module contain every class from the Artist panel
# It is used for the routing (for the subdomain)
module Artist
  # The class is the parent of every class
  class ArtistsController < ApplicationController
  	layout 'artist'

    before_action :cors_set_access_control_headers
    before_filter :authenticate_user!

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
  end
end
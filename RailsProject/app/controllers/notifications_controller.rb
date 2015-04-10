class NotificationsController < ApplicationController
	def initialize_session
    # perform application setup here
    controller_store[:users_id] = []
  end
end

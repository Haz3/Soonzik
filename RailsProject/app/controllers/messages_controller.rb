class MessagesController < WebsocketRails::BaseController
	def initialize_session
    # perform application setup here
    controller_store[:users_id] = []
  end

  def client_connected
 		controller_store[:users_id] << current_user.id
 		broadcast_message :connexion, { message: "Nouvelle connexion de : " + current_user.username }
  end

  def delete_user
		controller_store[:users_id] - [current_user.id]
 		broadcast_message :deconnexion, { message: "Déconnexion de : " + current_user.username }
  end
  
  def sendMsg
    dest = User.find_by_id(message.to)
    if (dest != nil && current_user.hasFriend?(dest))
      newMsg = Message.new
      newMsg.msg = message.data
      newMsg.user_id = current_user
      newMsg.dest_id = message.to
   		broadcast_message :new_message, { message: message, from: current_user.username }
    end
  end
end

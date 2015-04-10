class MessagesController < WebsocketRails::BaseController
	def initialize_session
    # perform application setup here
    controller_store[:users_id] = []
  end

  def client_connected
  	if (current_user != nil)
  		controller_store[:users_id] << current_user.id
  		broadcast_message :connexion, { message: "Nouvelle connexion de : " + current_user.username }
  	else
 			broadcast_message :connexion, { message: "Nouvelle connexion d'un inconnu" }
  	end
  end

  def delete_user
  	if (current_user != nil)
  		controller_store[:users_id] - [current_user.id]
  		broadcast_message :connexion, { message: "Déconnexion de : " + current_user.username }
  	else
 			broadcast_message :connexion, { message: "Déconnexion d'un inconnu" }
  	end
  end
  
  def sendMsg
  	if (current_user != nil)
  		broadcast_message :new_message, { message: message, from: current_user.username }
  	else
 			broadcast_message :new_message, { message: message, from: "Inconnu" }
  	end
  end
end

class MessagesController < WebsocketRails::BaseController
	def initialize_session
    # perform application setup here
    controller_store[:user_id] = []
  end

  def client_connected
    if user_signed_in?
      controller_store[:user_id] << current_user.id
      current_user.friends.each { |friend|
        controller_store[:user_id].each { |connected_guy|
          if friend.id == connected_guy
            WebsocketRails.users[connected_guy].send_message('newOnlineFriends', { :idFriend => current_user.id })
          end
        }
      }
    end
  end

  def delete_user
    if user_signed_in?
      controller_store[:user_id] -= [current_user.id]
      current_user.friends.each { |friend|
        controller_store[:user_id].each { |connected_guy|
          if friend.id == connected_guy
            WebsocketRails.users[connected_guy].send_message('newOfflineFriends', { :idFriend => current_user.id })
          end
        }
      }
    end
  end
  
  def sendMsg
    if (user_signed_in? && defined?message[:toWho])
      target = User.find_by_id(message[:toWho]);
      if (target != nil)
        newMsg = Message.new
        newMsg.msg = message[:messageValue]
        newMsg.user_id = current_user.id
        newMsg.dest_id = target.id
        newMsg.session = "web"
        newMsg.save!
        WebsocketRails.users[target.id].send_message('newMsg', { message: message[:messageValue], from: current_user.username })
      end
    end
  end

  def getOnlineFriend
    friends = []
    if (user_signed_in?)
      current_user.friends.each { |friend|
        controller_store[:user_id].each { |connected_guy|
          friends << connected_guy if friend.id == connected_guy
        }
      }
      WebsocketRails.users[current_user.id].send_message('onlineFriends', {:message => friends})
    end
  end
end

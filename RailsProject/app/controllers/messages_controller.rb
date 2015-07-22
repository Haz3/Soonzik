class MessagesController < WebsocketRails::BaseController
	def initialize_session
    # perform application setup here
    controller_store[:user_id] = []
  end

  def client_connected
    checkKey(message)
    if user_signed_in? || @security
      controller_store[:user_id] << @user.id
      @user.friends.each { |friend|
        controller_store[:user_id].each { |connected_guy|
          if friend.id == connected_guy
            WebsocketRails.users[connected_guy].send_message('newOnlineFriends', { :idFriend => @user.id })
          end
        }
      }
    end
  end

  def delete_user
    checkKey(message)
    if user_signed_in? || @security
      controller_store[:user_id] -= [@user.id]
      @user.friends.each { |friend|
        controller_store[:user_id].each { |connected_guy|
          if friend.id == connected_guy
            WebsocketRails.users[connected_guy].send_message('newOfflineFriends', { :idFriend => @user.id })
          end
        }
      }
    end
  end
  
  def sendMsg
    checkKey(message)
    if ((user_signed_in? || @security) && defined?message[:toWho])
      target = User.find_by_id(message[:toWho]);
      if (target != nil)
        newMsg = Message.new
        newMsg.msg = message[:messageValue]
        newMsg.user_id = @user.id
        newMsg.dest_id = target.id
        newMsg.session = "web"
        newMsg.save!
        WebsocketRails.users[target.id].send_message('newMsg', { message: message[:messageValue], from: @user.username })
      end
    end
  end

  def getOnlineFriend
    checkKey(message)
    friends = []
    if (user_signed_in? || @security)
      @user.friends.each { |friend|
        controller_store[:user_id].each { |connected_guy|
          friends << connected_guy if friend.id == connected_guy
        }
      }
      WebsocketRails.users[@user.id].send_message('onlineFriends', {:message => friends})
    end
  end

  private
  def checkKey(message)
    @security = false
    if (message.has_key?(:user_id) && message.has_key?(:secureKey))
      begin
        u = User.find_by_id(@user_id)
        if (message[:secureKey] == u.secureKey)
          @security = true
          @user = u
          u.regenerateKey
          u.save
        end
      rescue
      end
    elsif (user_signed_in?)
      @user = current_user
    end
  end
end

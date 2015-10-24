class MessagesController < WebsocketRails::BaseController
  def initialize_session
    # perform application setup here
    controller_store[:user_id] = []
  end

  def client_connected
    if !user_signed_in?
      controller_store[:user_id] << { id: nil, socket: self.connection }
    else
      controller_store[:user_id] << { id: current_user.id, socket: self.connection }
      current_user.friends.each { |friend|
        controller_store[:user_id].each { |connected_guy|
          if friend.id == connected_guy[:id]
            connected_guy[:socket].send_message('newOnlineFriends', { :idFriend => current_user.id }.to_json)
          end
        }
      }
    end
  end

  def init_smartphone_connection
    @user = nil
    begin
      @user = Message.checkKey(message, (user_signed_in?) ? current_user : nil)
    rescue
    end
    if @user != nil
      controller_store[:user_id].each_with_index { |user, index|
        if (user[:socket] == self.connection)
          user[:id] = @user.id
          break
        end
      }
      @user.friends.each { |friend|
        controller_store[:user_id].each { |connected_guy|
          if friend.id == connected_guy[:id]
            connected_guy[:socket].send_message('newOnlineFriends', { :idFriend => @user.id }.to_json)
          end
        }
      }
    end
  end

  def delete_user
    user_id = nil
    controller_store[:user_id].each_with_index { |user, index|
      if (user[:socket] == self.connection)
        user_id = user[:id]
        controller_store[:user_id].delete_at(index)
        break
      end
    }
    if (user_id != nil && (u = User.find_by_id(user_id)))
      u.friends.each { |friend|
        controller_store[:user_id].each { |connected_guy|
          if friend.id == connected_guy[:id]
            connected_guy[:socket].send_message('newOfflineFriends', { :idFriend => user_id }.to_json)
          end
        }
      }
    end
  end

  def sendMsg
    @user = nil
    begin
      @user = Message.checkKey(message, (user_signed_in?) ? current_user : nil)
    rescue
    end
    if (@user != nil && defined?message["toWho"])
      target = User.find_by_id(message["toWho"]);
      if (target != nil)
        newMsg = Message.new
        newMsg.msg = message["messageValue"]
        newMsg.user_id = @user.id
        newMsg.dest_id = target.id
        newMsg.session = "web"
        newMsg.save!
        controller_store[:user_id].each_with_index { |user, index|
          if (user[:id] == target.id)
            user[:socket].send_message('newMsg', { message: message["messageValue"], from: @user.username }.to_json)
            break
          end
        }
      end
    end
  end

  def getOnlineFriend
    @user = nil
    begin
      @user = Message.checkKey(message, (user_signed_in?) ? current_user : nil)
    rescue
    end
    friends = []
    if (@user != nil)
      u = nil
      @user.friends.each { |friend|
        controller_store[:user_id].each { |connected_guy|
          friends << connected_guy[:id] if friend.id == connected_guy[:id]
        }
      }
      controller_store[:user_id].each_with_index { |user, index|
        if (user[:id] == @user.id)
          user[:socket].send_message('onlineFriends', {:message => friends}.to_json)
          break
        end
      }
    end
  end
end

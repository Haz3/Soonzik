module API
  # Controller which manage the transaction for the Users objects
  # Here is the list of action available :
  #
  # * index       [get]
  # * show        [get]
  # * find        [get]
  # * save        [post]
  # * update      [post] - SECURE
  # * getmusics   [get] - SECURE
  # * isartist    [get]
  # * follow      [post] - SECURE
  # * unfollow    [post] - SECURE
  # * addfriend   [post] - SECURE
  # * delfriend   [post] - SECURE
  # * getFriends  [get]
  # * getFollows  [get]
  # * getFollowers[get]
  #
  class UsersController < ApisecurityController
    before_action :checkKey, only: [:getmusics, :save, :update, :follow, :unfollow, :addfriend, :delfriend]

  	# Retrieve all the users
    #
    # Route : /users
    #
    # ===== HTTP VALUE
    # 
    # - +200+ - In case of success, return a list of users
    # - +503+ - Error from server
    # 
    def index
      begin
        @returnValue = { content: User.all.as_json(:only => User.miniKey) }
        if (@returnValue[:content].size == 0)
          codeAnswer 202
        else
          codeAnswer 200
        end
      rescue
        codeAnswer 504
        defineHttp :service_unavailable
      end
      sendJson
    end

  	# Give a specific object by its id
    #
    # Route : /users/:id
    #
    # ==== Options
    # 
    # * +id+ - The id of the specific user
    # 
    # ===== HTTP VALUE
    # 
    # - +200+ - In case of success, return an user
    # - +404+ - Can't find the user, the id is probably wrong
    # - +503+ - Error from server
    # 
    def show
      begin
        user = User.find_by_id(@id)
        if (!user)
          codeAnswer 502
          defineHttp :not_found
        else
          @returnValue = { content: user.as_json(:only => User.bigKey) }
          codeAnswer 200
        end
      rescue
        codeAnswer 504
        defineHttp :service_unavailable
      end
      sendJson
    end

  	# Give a part of the albums depending of the filter passed into parameter
    #
    # Route : /users/find
    #
    # ==== Options
    # 
    # * +attribute [attribute_name]+ - If you want a column equal to a specific value
    # * +order_by_asc []+ - If you want to order by ascending by values
    # * +order_by_desc []+ - If you want to order by descending by values
    # * +group_by []+ - If you want to group by field
    # * +limit+ - The number of row you want
    # * +offset+ - The offset of the array
    # 
    # ==== Example
    #
    #     http://api.soonzik.com/users/find?attribute[address_id]=1&order_by_desc[]=id&group_by[]=username
    #     Note : By default, if you precise no attribute, it will take every row
    #
    # ===== HTTP VALUE
    # 
    # - +200+ - In case of success, return a list of users
    # - +503+ - Error from server
    # 
    def find
      begin
        user_object = nil
        if (defined?@attribute)
          # - - - - - - - -
          @attribute.each do |x, y|
            condition = ""
            if (y[0] == "%" && y[-1] == "%")  #LIKE
              condition = ["'users'.? LIKE ?", %Q[#{x}], "%#{y[1...-1]}%"];
            else                              #WHERE
              condition = {x => y};
            end

            if (user_object == nil)          #user_object doesn't exist
              user_object = User.where(condition)
            else                              #user_object exists
              user_object = user_object.where(condition)
            end
          end
          # - - - - - - - -
        else
          user_object = User.all            #no attribute specified
        end

        order_asc = ""
        order_desc = ""
        # filter the order by asc to create the string
        if (defined?@order_by_asc)
          @order_by_asc.each do |x|
            order_asc += ", " if order_asc.size != 0
            order_asc += (%Q[#{x}] + " ASC")
          end
        end
        # filter the order by desc to create the string
        if (defined?@order_by_desc)
          @order_by_desc.each do |x|
            order_desc += ", " if order_desc.size != 0
            order_desc += (%Q[#{x}] + " DESC")
          end
        end

        if (order_asc.size > 0 && order_desc.size > 0)
          user_object = user_object.order(order_asc + ", " + order_desc)
        elsif (order_asc.size == 0 && order_desc.size > 0)
          user_object = user_object.order(order_desc)
        elsif (order_asc.size > 0 && order_desc.size == 0)
          user_object = user_object.order(order_asc)
        end

        if (defined?@group_by)    #group
          group = []
          @group_by.each do |x|
            group << %Q[#{x}]
          end
          user_object = user_object.group(group.join(", "))
        end

        if (defined?@limit)       #limit
          user_object = user_object.limit(@limit.to_i)
        end
        if (defined?@offset)      #offset
          user_object = user_object.offset(@offset.to_i)
        end

        @returnValue = { content: user_object.as_json(:only => User.miniKey) }

        if (user_object.size == 0)
          codeAnswer 202
        else
          codeAnswer 200
        end

      rescue
        codeAnswer 504
        defineHttp :service_unavailable
      end
      sendJson
    end

    # To get all the musics buy by the user
    #
    # Route : /users/getmusics
    #
    # ===== HTTP VALUE
    # 
    # - +200+ - In case of success, return an hash like this : { musics: [], albums: [], packs: [] }
    # - +401+ - It is not a secured transaction
    # - +503+ - Error from server
    # 
    def getmusics
      begin
        if (@security)
          user = User.find_by_id(@user_id)
          list = user.purchases
          contentReturn = { musics: [], albums: [], packs: []}

          list.each do |x|
            if (x.musics != nil)
              contentReturn[:musics] = contentReturn[:musics] | [x.musics]
            elsif (x.albums != nil)
              contentReturn[:albums] = contentReturn[:albums] | [{ album: x.albums, musics: x.albums.musics }]
            elsif (x.packs != nil)
              value = { pack: x.packs, albums: [] }
              x.packs.albums.each do |album|
                value[:albums] << { album: album, musics: album.musics }
              end
              contentReturn[:packs] = contentReturn[:packs] | [value]
            end
          end
          @returnValue = { content: contentReturn }
          codeAnswer 200
        else
          codeAnswer 500
          defineHttp :forbidden
        end
      rescue
        codeAnswer 504
        defineHttp :service_unavailable
      end
      sendJson
    end

    # Save a new object User. For more information on the parameters, check at the model
    # 
    # Route : /users/save
    #
    # ==== Options
    # 
    # * +user [email]+ - Email of the user
    # * +user [password]+ - Password of the user, not hashed
    # * +user [username]+ - Unique username of the user
    # * +user [birthday]+ - Birthday day with the format : "YYYY-MM-JJ HH:II:SS" you can add '+HH:II' for the GTM
    # * +user [language]+ - Tiny string for the language. Need to be in our language list.
    # * +user [fname]+ - (optionnal) Firstname of the user
    # * +user [lname]+ - (optionnal) Lastname of the user
    # * +user [description]+ - (optionnal) Description of the user
    # * +user [phoneNumber]+ - (optionnal) Phone number of the user. Need to be with the format '+code phonenumber'
    # * +user [facebook]+ - (optionnal) The facebook name after "https://www.facebook.com/" when you are in your profile
    # * +user [twitter]+ - (optionnal) The twitter name after "https://www.twitter.com/" when you are in your profile
    # * +user [googlePlus]+ - (optionnal) The G+ name after "https://plus.google.com/" when you are in your profile
    # * +address [numberStreet]+ - (optionnal if you don't provide anything in the address variable) Number of the street
    # * +address [complement]+ - (optionnal) Other informations if needed
    # * +address [street]+ - (optionnal if you don't provide anything in the address variable) The street name
    # * +address [city]+ - (optionnal if you don't provide anything in the address variable) The city name
    # * +address [country]+ - (optionnal if you don't provide anything in the address variable) The country name
    # * +address [zipcode]+ - (optionnal if you don't provide anything in the address variable) The Zipcode
    # 
    # ===== HTTP VALUE
    # 
    # - +201+ - In case of success, return the new user including its address, friends and follow.
    # - +503+ - Error from server
    # 
    def save
      _save(true, params)
      sendJson
    end

    # Update a specific object User. For more information on the parameters, check at the model.
    # You need to provide one of this following informations.
    # If the user has no address, you need to provide everything (expect 'complement' which is optionnal)
    # If the user has an address, just provide what you want to update
    # 
    # ==== Options
    # 
    # * +id+ - Same as user_id used for the authentication (get from the url)
    # * +user [email]+ - Email of the user
    # * +user [password]+ - Password of the user, not hashed
    # * +user [username]+ - Unique username of the user
    # * +user [birthday]+ - Birthday day with the format : "YYYY-MM-JJ HH:II:SS" you can add '+HH:II' for the GTM
    # * +user [language]+ - Tiny string for the language. Need to be in our language list.
    # * +user [fname]+ - Firstname of the user
    # * +user [lname]+ - Lastname of the user
    # * +user [description]+ - Description of the user
    # * +user [phoneNumber]+ - Phone number of the user. Need to be with the format '+code phonenumber'
    # * +user [facebook]+ - The facebook name after "https://www.facebook.com/" when you are in your profile
    # * +user [twitter]+ - The twitter name after "https://www.twitter.com/" when you are in your profile
    # * +user [googlePlus]+ - The G+ name after "https://plus.google.com/" when you are in your profile
    # * +address [numberStreet]+ - Number of the street
    # * +address [complement]+ - Other informations if needed
    # * +address [street]+ - The street name
    # * +address [city]+ - The city name
    # * +address [country]+ - The country name
    # * +address [zipcode]+ - The Zipcode
    # 
    # ===== HTTP VALUE
    # 
    # - +201+ - In case of success, return the new user including its address, friends and follow.
    # - +401+ - It is not a secured transaction
    # - +404+ - Can't find the user, the id is probably wrong
    # - +503+ - Error from server
    # 
    def update
      begin
        if (@security)
          user = User.find_by_id(@user_id)
          if user == nil
            codeAnswer 502
            defineHttp :not_found
            return
          else
            _save(false, params)
          end
        else
          codeAnswer 500
          defineHttp :forbidden
        end
      rescue
        codeAnswer 504
        defineHttp :service_unavailable
      end
      sendJson
    end

    # To get all the musics buy by the user
    #
    # Route : /users/:id/isartist
    #
    # ===== HTTP VALUE
    # 
    # - +200+ - In case of success, return an hash with the key "artist" to know if it is one or not, and if yes, the list of albums & musics of him
    # - +404+ - The user doesn't exist
    # - +503+ - Error from server
    # 
    def isArtist
      begin
        u = User.find_by_id(@id)

        if (!u)
          codeAnswer 502
          defineHttp :not_found
        else
          hash = { artist: u.isArtist? }
          if hash[:artist]
            hash[:albums] = JSON.parse(u.albums.to_json(:only => Album.miniKey, :include => {
                                                musics: { only: Music.miniKey }
                                              } ))
            topFive = u.giveTopFive
            hash[:topFive] = []
            topFive.each { |music|
              hash[:topFive] << { note: music[:note], music: JSON.parse(music[:object].to_json(only: Music.miniKey, :include => {
                  album: { only: Album.miniKey }
                })) }
            }
          end
          @returnValue = { content: hash }
          codeAnswer 200
        end
      rescue
        codeAnswer 504
        defineHttp :service_unavailable
      end
      sendJson
    end

    # To follow someone
    #
    # Route : /users/follow
    #
    # ==== Options
    # 
    # * +follow_id+ - id of the user you want to follow
    #
    # ===== HTTP VALUE
    # 
    # - +200+ - In case of success
    # - +401+ - It is not a secured transaction
    # - +404+ - The user doesn't exist
    # - +405+ - You already follow this user
    # - +503+ - Error from server
    # 
    def follow
      begin
        if (@security)
          u = User.find_by_id(@user_id)
          toFollow = User.find_by_id(@follow_id)

          if (!u || !toFollow)
            codeAnswer 502
            defineHttp :not_found
          else
            code = 201
            http = :created
            u.follows.each { |follow|
              if follow == toFollow
                code = 405
                http = :method_not_allowed
              end
            }
            if code == 201
              u.follows << toFollow
              codeAnswer 201
            else
              codeAnswer 503
            end
            codeAnswer code
            defineHttp http
          end
        else
          codeAnswer 500
          defineHttp :forbidden
        end
      rescue
        codeAnswer 504
        defineHttp :service_unavailable
      end
      sendJson
    end

    # To unfollow someone
    #
    # Route : /users/unfollow
    #
    # ==== Options
    # 
    # * +follow_id+ - id of the user you want to follow
    #
    # ===== HTTP VALUE
    # 
    # - +200+ - In case of success
    # - +401+ - It is not a secured transaction
    # - +404+ - The user doesn't exist
    # - +405+ - You don't follow this user
    # - +503+ - Error from server
    # 
    def unfollow
      begin
        if (@security)
          u = User.find_by_id(@user_id)
          toFollow = User.find_by_id(@follow_id)

          if (!u || !toFollow)
            codeAnswer 502
            defineHttp :not_found
          else
            code = 405
            http = :method_not_allowed
            u.follows.each { |follow|
              if follow == toFollow
                code = 200
                http = :ok
              end
            }
            if code == 200
              u.follows.delete(toFollow)
              codeAnswer 200
            else
              codeAnswer 502
            end
            codeAnswer code
            defineHttp http
          end
        else
          codeAnswer 500
          defineHttp :forbidden
        end
      rescue
        codeAnswer 504
        defineHttp :service_unavailable
      end
      sendJson
    end

    # To add a friend
    #
    # Route : /users/addfriend
    #
    # ==== Options
    # 
    # * +friend_id+ - id of the user you want to add to your friendlist
    #
    # ===== HTTP VALUE
    # 
    # - +200+ - In case of success
    # - +401+ - It is not a secured transaction
    # - +404+ - The user doesn't exist
    # - +405+ - You already have this user in your friendlist
    # - +503+ - Error from server
    # 
    def addfriend
      begin
        if (@security)
          u = User.find_by_id(@user_id)
          friend = User.find_by_id(@friend_id)

          if (!u || !friend)
            codeAnswer 502
            defineHttp :not_found
          else
            code = 201
            http = :created
            u.friends.each { |friendInList|
              if friendInList == friend
                code = 405
                http = :method_not_allowed
              end
            }
            if code == 201
              u.friends << friend
              friend.friends << u
              codeAnswer 201
            else
              codeAnswer 502
            end
            codeAnswer code
            defineHttp http
          end
        else
          codeAnswer 500
          defineHttp :forbidden
        end
      rescue
        codeAnswer 504
        defineHttp :service_unavailable
      end
      sendJson
    end

    # To delete a friend
    #
    # Route : /users/delfriend
    #
    # ==== Options
    # 
    # * +friend_id+ - id of the user you want to delete of your friendlist
    #
    # ===== HTTP VALUE
    # 
    # - +200+ - In case of success
    # - +401+ - It is not a secured transaction
    # - +404+ - The user doesn't exist
    # - +405+ - You don't have this user in your friendlist
    # - +503+ - Error from server
    # 
    def delfriend
      begin
        if (@security)
          u = User.find_by_id(@user_id)
          friend = User.find_by_id(@friend_id)

          if (!u || !friend)
            codeAnswer 502
            defineHttp :not_found
          else
            code = 405
            http = :method_not_allowed
            u.friends.each { |friendInList|
              if friendInList == friend
                code = 200
                http = :ok
              end
            }
            if code == 200
              u.friends.delete(friend)
              friend.friends.delete(u)
              codeAnswer 200
            else
              codeAnswer 502
            end
            codeAnswer code
            defineHttp http
          end
        else
          codeAnswer 500
          defineHttp :forbidden
        end
      rescue
        codeAnswer 504
        defineHttp :service_unavailable
      end
      sendJson
    end

    # To get the friends of an user
    #
    # Route : /users/:id/friends
    #
    # ==== Options
    # 
    # * +id+ - id of the user you want to get the friendlist
    #
    # ===== HTTP VALUE
    # 
    # - +200+ - In case of success, return an array of users
    # - +404+ - The user doesn't exist
    # - +503+ - Error from server
    # 
    def getFriends
      begin
        u = User.find_by_id(@id)

        if (!u)
          codeAnswer 502
          defineHttp :not_found
        else
          @returnValue = { content: u.friends.as_json(:only => User.miniKey) }
          codeAnswer 200
        end
      rescue
        codeAnswer 504
        defineHttp :service_unavailable
      end
      sendJson
    end

    # To get the follows of an user
    #
    # Route : /users/:id/follows
    #
    # ==== Options
    # 
    # * +id+ - id of the user you want to get the follows
    #
    # ===== HTTP VALUE
    # 
    # - +200+ - In case of success, return an array of users
    # - +404+ - The user doesn't exist
    # - +503+ - Error from server
    # 
    def getFollows
      begin
        u = User.find_by_id(@id)

        if (!u)
          codeAnswer 502
          defineHttp :not_found
        else
          @returnValue = { content: u.follows.as_json(:only => User.miniKey) }
          codeAnswer 200
        end
      rescue
        codeAnswer 504
        defineHttp :service_unavailable
      end
      sendJson
    end

    # To get the followers of an user
    #
    # Route : /users/:id/followers
    #
    # ==== Options
    # 
    # * +id+ - id of the user you want to get the followers
    #
    # ===== HTTP VALUE
    # 
    # - +200+ - In case of success, return an array of users
    # - +404+ - The user doesn't exist
    # - +503+ - Error from server
    # 
    def getFollowers
      begin
        u = User.find_by_id(@id)

        if (!u)
          codeAnswer 502
          defineHttp :not_found
        else
          @returnValue = { content: u.followers.as_json(:only => User.miniKey) }
          codeAnswer 200
        end
      rescue
        codeAnswer 504
        defineHttp :service_unavailable
      end
      sendJson
    end

    private
    # Common code for save/update (private method)
    # 
    # ==== Attributes
    # 
    # * +save+ - A boolean. True = save, False = update
    # * +params+ - The params in an hash {user: @user, address: @address}
    # 
    def _save(save, params)
      begin
        user = nil
        if (@security && save == false)
          user = User.find_by_id(@user_id)
          update_user = false
          update_address = true
          update_user = user.update(User.user_params params)

          update_address = user.address.update(Address.address_params params)   if user.address != nil && params.has_key?(:address)
          address = Address.new(Address.address_params params)                  if user.address == nil && params.has_key?(:address)
          update_address = address.save                                         if user.address == nil && params.has_key?(:address)
          user.address = address                                                if user.address == nil && params.has_key?(:address) && update_address

          if ((update_user && update_address))
            @returnValue = { content: user.as_json(:include => {
                                                                  :address => { :only => Address.miniKey }
                                                                },
                                                    :only => User.bigKey) }
            codeAnswer 201
            defineHttp :created
          else
            @returnValue = { content: { user: JSON.parse(user.errors.to_hash.to_json), address: JSON.parse(user.address.errors.to_hash.to_json) } } if user.address != nil
            @returnValue = { content: { user: JSON.parse(user.errors.to_hash.to_json), address: {} } } if user.address == nil
            codeAnswer 505
            defineHttp :service_unavailable
          end
          return
        else
          user = User.new(User.user_params params)
        end

        address = true
        address = Address.new(Address.address_params params) if params.has_key?(:address)
        if (address == true || address.save)
          user.address_id = address.id if address != true
          user.skip_confirmation!
          if (user.save!)
            @returnValue = { content: user.as_json(:include => {
                                                                  :address => { :only => Address.miniKey }
                                                                },
                                                    :only => User.bigKey) }
            codeAnswer 201
            defineHttp :created
          else
            @returnValue = { content: JSON.parse(user.errors.to_hash.to_json) }
            codeAnswer 503
            defineHttp :service_unavailable
          end
        else
          @returnValue = { content: JSON.parse(address.errors.to_hash.to_json) }
          codeAnswer 503
          defineHttp :service_unavailable
        end
      rescue
        puts $!, $@
        codeAnswer 504
        defineHttp :service_unavailable
      end
    end
  end
end
module API
  # Controller which manage the transaction for the Users objects
  # Here is the list of action available :
  #
  # * index       [get]
  # * show        [get]
  # * find        [get]
  # * save        [post]
  # * getmusics   [get] - SECURITY
  #
  class UsersController < ApisecurityController
  	# Retrieve all the users
    def index
      begin
        @returnValue = { content: User.all.as_json(:include => :address) }
        if (@returnValue.size == 0)
          codeAnswer 202
        else
          codeAnswer 200
        end
      rescue
        codeAnswer 504
      end
      sendJson
    end

  	# Give a specific object by its id
    #
    # ==== Options
    # 
    # * +:id+ - The id of the specific user
    # 
    def show
      begin
        user = User.find_by_id(@id)
        if (!user)
          codeAnswer 502
          return
        end
        @returnValue = { content: user.as_json(:include => :address) }
        codeAnswer 200
      rescue
        codeAnswer 504
      end
      sendJson
    end

  	# Give a part of the albums depending of the filter passed into parameter
    #
    # ==== Options
    # 
    # * +:attribute[attribute_name]+ - If you want a column equal to a specific value
    # * +:order_by_asc[]+ - If you want to order by ascending by values
    # * +:order_by_desc[]+ - If you want to order by descending by values
    # * +:group_by[]+ - If you want to group by field
    # * +:limit+ - The number of row you want
    # * +:offset+ - The offset of the array
    # 
    # ==== Example
    #
    #     http://api.soonzik.com/users/find?attribute[address_id]=1&order_by_desc[]=id&group_by[]=username
    #     Note : By default, if you precise no attribute, it will take every row
    #
    def find
      begin
        if (defined?@attribute)
          user_object = nil
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

        @returnValue = { content: user_object.as_json(:include => :address) }

        if (user_object.size == 0)
          codeAnswer 202
        else
          codeAnswer 200
        end

      rescue
        codeAnswer 504
      end
      sendJson
    end

    # To get all the musics buy by the user
    def getmusics
      begin
        if (@security)
          user = User.find_by_id(@user_id)
          list = user.purcharses
          contentReturn = []

          list.each do |x|
            classObj = x.typeObj.constantize
            obj = classObj.find_by_id(x.obj_id)
            if (obj != nil && classObj == "Album")
              contentReturn << { album: obj, musics: obj.musics }
            elsif (obj != nil && classObj == "Music")
              contentReturn << obj
            elsif (obj != nil && classObj == "Pack")
              value = { pack: obj, albums: [] }
              obj.albums.each do |album|
                value[:albums] << { album: album, musics: album.musics }
              end
              contentReturn << value
            end
          end
          @returnValue = { content: contentReturn }
        else
          codeAnswer 500
        end
      rescue
        codeAnswer 504
      end
      sendJson
    end

    # Save a new object User. For more information on the parameters, check at the model
    # 
    # ==== Options
    # 
    # * +:user[email]+ - Email of the user
    # * +:user[password]+ - Password of the user, not hashed
    # * +:user[username]+ - Unique username of the user
    # * +:user[birthday]+ - Birthday day with the format : "YYYY-MM-JJ HH:II:SS" you can add '+HH:II' for the GTM
    # * +:user[language]+ - Tiny string for the language. Need to be in our language list.
    # * +:user[fname]+ - (optionnal) Firstname of the user
    # * +:user[lname]+ - (optionnal) Lastname of the user
    # * +:user[description]+ - (optionnal) Description of the user
    # * +:user[phoneNumber]+ - (optionnal) Phone number of the user. Need to be with the format '+code phonenumber'
    # * +:user[facebook]+ - (optionnal) The facebook name after "https://www.facebook.com/" when you are in your profile
    # * +:user[twitter]+ - (optionnal) The twitter name after "https://www.twitter.com/" when you are in your profile
    # * +:user[googlePlus]+ - (optionnal) The G+ name after "https://plus.google.com/" when you are in your profile
    # * +:address[numberStreet]+ - (optionnal if you don't provide anything in the address variable) Number of the street
    # * +:address[complement]+ - (optionnal) Other informations if needed
    # * +:address[street]+ - (optionnal if you don't provide anything in the address variable) The street name
    # * +:address[city]+ - (optionnal if you don't provide anything in the address variable) The city name
    # * +:address[country]+ - (optionnal if you don't provide anything in the address variable) The country name
    # * +:address[zipcode]+ - (optionnal if you don't provide anything in the address variable) The Zipcode
    # 
    def save
      _save(true, {:user => @user, :address => @address })
      sendJson
    end

    # Update a specific object User. For more information on the parameters, check at the model.
    # You need to provide one of this following informations.
    # If the user has no address, you need to provide everything (expect 'complement' which is optionnal)
    # If the user has an address, just provide what you want to update
    # 
    # ==== Options
    # 
    # * +:id+ - Same as user_id used for the authentication (get from the url)
    # * +:user[email]+ - Email of the user
    # * +:user[password]+ - Password of the user, not hashed
    # * +:user[username]+ - Unique username of the user
    # * +:user[birthday]+ - Birthday day with the format : "YYYY-MM-JJ HH:II:SS" you can add '+HH:II' for the GTM
    # * +:user[language]+ - Tiny string for the language. Need to be in our language list.
    # * +:user[fname]+ - Firstname of the user
    # * +:user[lname]+ - Lastname of the user
    # * +:user[description]+ - Description of the user
    # * +:user[phoneNumber]+ - Phone number of the user. Need to be with the format '+code phonenumber'
    # * +:user[facebook]+ - The facebook name after "https://www.facebook.com/" when you are in your profile
    # * +:user[twitter]+ - The twitter name after "https://www.twitter.com/" when you are in your profile
    # * +:user[googlePlus]+ - The G+ name after "https://plus.google.com/" when you are in your profile
    # * +:address[numberStreet]+ - Number of the street
    # * +:address[complement]+ - Other informations if needed
    # * +:address[street]+ - The street name
    # * +:address[city]+ - The city name
    # * +:address[country]+ - The country name
    # * +:address[zipcode]+ - The Zipcode
    # 
    def update
      begin
        if (@security && @id == @user_id)
          _save(false, {:user => @user, :address => @address })
        else
          codeAnswer 500
        end
      rescue
        codeAnswer 504
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
          user.update(params[:user])
        else
          user = User.new(params[:user])
        end

        # On update, we get the current address, else we keep address to nil
        address = user.address
        address = Address.new(params[:address]) if address == nil
        address.update(params[:address]) if address != nil
        if (address.save)
          user.address_id = address.id
          if (user.save)
            @returnValue = { content: user.as_json(:include => :address) }
            codeAnswer 201
          else
            codeAnswer 505
          end
        else
          codeAnswer 503
        end
      rescue
        codeAnswer 504
      end
      sendJson
    end
  end
end
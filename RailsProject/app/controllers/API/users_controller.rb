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
  #
  class UsersController < ApisecurityController
    before_action :checkKey, only: [:getmusics, :save, :update]

  	# Retrieve all the users
    def index
      begin
        @returnValue = { content: User.all.as_json(:include => {
                                                                  :address => {},
                                                                  :friends => {},
                                                                  :follows => {}
                                                                },
                                                    :only => User.miniKey) }
        if (@returnValue[:content].size == 0)
          codeAnswer 202
          defineHttp :no_content
        else
          codeAnswer 200
        end
      rescue
        puts $!, $@
        codeAnswer 504
        defineHttp :service_unavailable
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
          defineHttp :not_found
        else
          @returnValue = { content: user.as_json(:include => {
                                                                  :address => {},
                                                                  :friends => {},
                                                                  :follows => {}
                                                                },
                                                    :only => User.bigKey) }
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
    # ==== Options
    # 
    # * +:attribute [attribute_name]+ - If you want a column equal to a specific value
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

        @returnValue = { content: user_object.as_json(:include => {
                                                                  :address => {},
                                                                  :friends => {},
                                                                  :follows => {}
                                                                },
                                                    :only => User.miniKey) }

        if (user_object.size == 0)
          codeAnswer 202
          defineHttp :no_content
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
    # ==== Options
    # 
    # * +:user [email]+ - Email of the user
    # * +:user [password]+ - Password of the user, not hashed
    # * +:user [username]+ - Unique username of the user
    # * +:user [birthday]+ - Birthday day with the format : "YYYY-MM-JJ HH:II:SS" you can add '+HH:II' for the GTM
    # * +:user [language]+ - Tiny string for the language. Need to be in our language list.
    # * +:user [fname]+ - (optionnal) Firstname of the user
    # * +:user [lname]+ - (optionnal) Lastname of the user
    # * +:user [description]+ - (optionnal) Description of the user
    # * +:user [phoneNumber]+ - (optionnal) Phone number of the user. Need to be with the format '+code phonenumber'
    # * +:user [facebook]+ - (optionnal) The facebook name after "https://www.facebook.com/" when you are in your profile
    # * +:user [twitter]+ - (optionnal) The twitter name after "https://www.twitter.com/" when you are in your profile
    # * +:user [googlePlus]+ - (optionnal) The G+ name after "https://plus.google.com/" when you are in your profile
    # * +:address [numberStreet]+ - (optionnal if you don't provide anything in the address variable) Number of the street
    # * +:address [complement]+ - (optionnal) Other informations if needed
    # * +:address [street]+ - (optionnal if you don't provide anything in the address variable) The street name
    # * +:address [city]+ - (optionnal if you don't provide anything in the address variable) The city name
    # * +:address [country]+ - (optionnal if you don't provide anything in the address variable) The country name
    # * +:address [zipcode]+ - (optionnal if you don't provide anything in the address variable) The Zipcode
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
    # * +:id+ - Same as user_id used for the authentication (get from the url)
    # * +:user [email]+ - Email of the user
    # * +:user [password]+ - Password of the user, not hashed
    # * +:user [username]+ - Unique username of the user
    # * +:user [birthday]+ - Birthday day with the format : "YYYY-MM-JJ HH:II:SS" you can add '+HH:II' for the GTM
    # * +:user [language]+ - Tiny string for the language. Need to be in our language list.
    # * +:user [fname]+ - Firstname of the user
    # * +:user [lname]+ - Lastname of the user
    # * +:user [description]+ - Description of the user
    # * +:user [phoneNumber]+ - Phone number of the user. Need to be with the format '+code phonenumber'
    # * +:user [facebook]+ - The facebook name after "https://www.facebook.com/" when you are in your profile
    # * +:user [twitter]+ - The twitter name after "https://www.twitter.com/" when you are in your profile
    # * +:user [googlePlus]+ - The G+ name after "https://plus.google.com/" when you are in your profile
    # * +:address [numberStreet]+ - Number of the street
    # * +:address [complement]+ - Other informations if needed
    # * +:address [street]+ - The street name
    # * +:address [city]+ - The city name
    # * +:address [country]+ - The country name
    # * +:address [zipcode]+ - The Zipcode
    # 
    def update
      begin
        if (@security && @id == @user_id)
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
                                                                  :address => {},
                                                                  :friends => {},
                                                                  :follows => {}
                                                                },
                                                    :only => User.miniKey) }
            codeAnswer 201
            defineHttp :created
          else
            @returnValue = { content: user.errors.to_hash.to_json }
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
                                                                  :address => {},
                                                                  :friends => {},
                                                                  :follows => {}
                                                                },
                                                    :only => User.miniKey) }
            codeAnswer 201
            defineHttp :created
          else
            @returnValue = { content: user.errors.to_hash.to_json }
            codeAnswer 503
            defineHttp :service_unavailable
          end
        else
          @returnValue = { content: address.errors.to_hash.to_json }
          codeAnswer 503
          defineHttp :service_unavailable
        end
      rescue
        codeAnswer 504
        defineHttp :service_unavailable
      end
    end
  end
end
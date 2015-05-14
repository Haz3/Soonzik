module API
  # Controller which manage the transaction for the Carts objects
  # Here is the list of action available :
  #
  # * find        [get] - SECURE
  # * save       	[post] - SECURE
  # * destroy     [get] - SECURE
  #
  class CartsController < ApisecurityController
    before_action :checkKey, only: [:destroy, :save, :find]

  	# Destroy a specific object by its id
    #
    # Route : /carts/destroy
    #
    # ==== Options
    # 
    # * +id+ - The id of the specific cart
    # 
    # ===== HTTP VALUE
    # 
    # - +200+ - In case of success, there is nothing to return
    # - +401+ - It is not a secured transaction
    # - +404+ - The cart was not found
    # - +503+ - Error from server
    # 
    def destroy
      begin
      	if (@security)
      	  object = Cart.find_by_id(@id)
          if (!object)
            codeAnswer 502
            defineHttp :not_found
            sendJson and return
          end
          if (object.user_id != @user_id.to_i)
            codeAnswer 500
            defineHttp :forbidden
            sendJson and return
          end
      	  object.destroy
      	  codeAnswer 202
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

    # Save a new object Cart. For more information on the parameters, check at the model
    # 
    # Route : /carts/save
    #
    # ==== Options
    # 
    # * +cart [user_id]+ - Id of the user who has the cart
    # * +cart [typeObj]+ - Model name of the object to add to the cart -> "Music" | "Album" | "Pack"
    # * +cart [obj_id]+ - Id of the object
    # * +cart [gift]+ - Boolean to know if it's a gift or not
    # 
    # ===== HTTP VALUE
    # 
    # - +201+ - In case of success, return the new item
    # - +403+ - It is not a secured transaction
    # - +503+ - Error from server
    # 
    def save
      begin
        if (@security && @cart[:user_id] == @user_id)
          raise ArgumentError, 'user_id missing' if (!defined?@cart[:user_id])
          raise ArgumentError, 'gift missing' if (!defined?@cart[:gift])
          raise ArgumentError, 'typeObj missing' if (!defined?@cart[:typeObj])
          raise ArgumentError, 'obj_id missing' if (!defined?@cart[:obj_id])

          cart = Cart.new
          cart.user_id = @cart[:user_id]
          cart.gift = @cart[:gift]
          classObj = @cart[:typeObj].constantize
          obj = classObj.find_by_id(@cart[:obj_id])
          # check if the object exists
          if (obj != nil)
            case @cart[:typeObj]
              when "Music"
                cart.musics << obj;
              when "Album"
                cart.albums << obj;
              when "Pack"
                cart.packs << obj;
            end

            if (cart.save)
              @returnValue = { content: cart.as_json(:include => {
                                                                    :user => {:only => User.miniKey() },
                                                                    :musics => { :only => Music.miniKey() },
                                                                    :albums => { :only => Album.miniKey() },
                                                                    :packs => { :only => Pack.miniKey() }
                                                                  }) }
              codeAnswer 201
              defineHttp :created
            else
              @returnValue = { content: cart.errors.to_hash.to_json }
              codeAnswer 503
              defineHttp :service_unavailable
            end
          else
            codeAnswer 503
            defineHttp :service_unavailable
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

    # Give a part of the carts depending of the filter passed into parameter
    #
    # Route : /carts/find
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
    #     http://api.soonzik.com/carts/find?attribute[user_id]=1&order_by_desc[]=user_id&group_by[]=user_id
    #     Note : By default, if you precise no attribute, it will take every row
    #
    # ===== HTTP VALUE
    # 
    # - +200+ - In case of success, return a list of cart items
    # - +503+ - Error from server
    # 
    def find
      begin
        if (!@security)
          codeAnswer 500
        else
          cart_object = Cart.where(user_id: @user_id)
          if (defined?@attribute)
            # - - - - - - - -
            @attribute.each do |x, y|
              condition = ""
              if (y.to_s[0] == "%" && y.to_s[-1] == "%")  #LIKE
                condition = ["'carts'.? LIKE ?", %Q[#{x}], "%#{y.to_s[1...-1]}%"];
              else                              #WHERE
                condition = {x => y};
              end

              if (cart_object == nil)          #cart_object doesn't exist
                cart_object = Cart.where(condition).where(user_id: @user_id)
              else                              #cart_object exists
                cart_object = cart_object.where(condition)
              end
            end
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
            cart_object = cart_object.order(order_asc + ", " + order_desc)
          elsif (order_asc.size == 0 && order_desc.size > 0)
            cart_object = cart_object.order(order_desc)
          elsif (order_asc.size > 0 && order_desc.size == 0)
            cart_object = cart_object.order(order_asc)
          end

          if (defined?@group_by)    #group
            group = []
            @group_by.each do |x|
              group << %Q[#{x}]
            end
            cart_object = cart_object.group(group.join(", "))
          end

          if (defined?@limit)       #limit
            cart_object = cart_object.limit(@limit.to_i)
          end
          if (defined?@offset)      #offset
            cart_object = cart_object.offset(@offset.to_i)
          end

          @returnValue = { content: cart_object.as_json(:include => {
                                                                    :user => {:only => User.miniKey() },
                                                                    :musics => { :only => Music.miniKey() },
                                                                    :albums => { :only => Album.miniKey() },
                                                                    :packs => { :only => Pack.miniKey() }
                                                                  }) }

          if (cart_object.size == 0)
            codeAnswer 202
          else
            codeAnswer 200
          end
        end
      rescue
        codeAnswer 504
        defineHttp :service_unavailable
      end
      sendJson
    end
  end
end
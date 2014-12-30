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
    # ==== Options
    # 
    # * +:id+ - The id of the specific cart
    # 
    def destroy
      begin
      	if (@security)
      	  object = Cart.find_by_id(@id);
      	  object.destroy
      	  codeAnswer 202
      	else
      	  codeAnswer 500
      	end
      rescue
      	codeAnswer 504
      end
      sendJson
    end

    # Save a new object Cart. For more information on the parameters, check at the model
    # 
    # ==== Options
    # 
    # * +:cart[user_id]+ - Id of the user who has the cart
    # * +:cart[typeObj]+ - Model name of the object to add to the cart
    # * +:cart[obj_id]+ - Id of the object
    # * +:cart[gift]+ - Boolean to know if it's a gift or not
    # 
    def save
      begin
        if (@security)
          cart = Cart.new(Cart.cart_params params)
          classObj = cart.typeObj.constantize
          # check if the object exists
          if (classObj.find_by_id(cart.obj_id) != nil && cart.save)
            @returnValue = { content: cart.as_json(:include => :user) }
            codeAnswer 201
          else
            @returnValue = { content: cart.errors.to_hash.to_json }
            codeAnswer 503
          end
        else
          codeAnswer 500
        end
      rescue
        codeAnswer 504
      end
      sendJson
    end

    # Give a part of the carts depending of the filter passed into parameter
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
    #     http://api.soonzik.com/carts/find?attribute[user_id]=1&order_by_desc[]=user_id&group_by[]=user_id
    #     Note : By default, if you precise no attribute, it will take every row
    #
    def find
      begin
        if (!@security)
          codeAnswer 500
        else
          cart_object = nil
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
            # - - - - - - - -
          else
            cart_object = Cart.where(user_id: @user_id)            #no attribute specified
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

          @returnValue = { content: cart_object.as_json(:include => :user) }

          if (cart_object.size == 0)
            codeAnswer 202
          else
            codeAnswer 200
          end
        end
      rescue
        codeAnswer 504
      end
      sendJson
    end
  end
end
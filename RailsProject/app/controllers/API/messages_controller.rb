module API
  # Controller which manage the transaction for the Messages objects
  # Here is the list of action available :
  #
  # * show        [get] - SECURE
  # * save		    [post]
  # * find        [get] - SECURE
  #
  class MessagesController < ApisecurityController
  	# Give a specific object by its id
    #
    # ==== Options
    # 
    # * +:id+ - The id of the specific message
    # 
    def show
      begin
      	if (@security)
	        msg = Message.find_by_id(@id)
	        if (!msg)
	          codeAnswer 502
	          return
	        end
	        @returnValue = { content: msg.as_json(:include => {
        														:sender => {},
        														:receiver => {}
        													}) }
	        codeAnswer 200
	    else
	    	codeAnswer 500
	    end
      rescue
        codeAnswer 504
      end
      sendJson
    end

    # Give a part of the messages depending of the filter passed into parameter
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
    #     http://api.soonzik.com/messages/find?attribute[user_id]=1&order_by_desc[]=user_id&group_by[]=user_id
    #     Note : By default, if you precise no attribute, it will take every row
    #
    def find
      begin
        if (!@security)
          codeAnswer 500
        else
          if (defined?@attribute)
            message_object = nil
            # - - - - - - - -
            @attribute.each do |x, y|
              condition = ""
              if (y[0] == "%" && y[-1] == "%")  #LIKE
                condition = ["'messages'.? LIKE ?", %Q[#{x}], "%#{y[1...-1]}%"];
              else                              #WHERE
                condition = {x => y};
              end

              if (message_object == nil)          #message_object doesn't exist
                message_object = Message.where(condition)
              else                              #message_object exists
                message_object = message_object.where(condition)
              end
            end
            # - - - - - - - -
          else
            message_object = Message.all            #no attribute specified
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
            message_object = message_object.order(order_asc + ", " + order_desc)
          elsif (order_asc.size == 0 && order_desc.size > 0)
            message_object = message_object.order(order_desc)
          elsif (order_asc.size > 0 && order_desc.size == 0)
            message_object = message_object.order(order_asc)
          end

          if (defined?@group_by)    #group
            group = []
            @group_by.each do |x|
              group << %Q[#{x}]
            end
            message_object = message_object.group(group.join(", "))
          end

          if (defined?@limit)       #limit
            message_object = message_object.limit(@limit.to_i)
          end
          if (defined?@offset)      #offset
            message_object = message_object.offset(@offset.to_i)
          end

          @returnValue = { content: message_object.as_json(:include => :user) }

          if (message_object.size == 0)
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
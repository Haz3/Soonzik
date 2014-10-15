module API
  # Controller which manage the transaction for the Notifications objects
  # Here is the list of action available :
  #
  # * show        [get] - SECURE
  # * save		    [post] - SECURE
  # * find        [get] - SECURE
  # * destroy     [get] - SECURE
  #
  class NotificationsController < ApisecurityController
  	# Give a specific object by its id
    #
    # ==== Options
    # 
    # * +:id+ - The id of the specific notification
    # 
    def show
      begin
      	if (@security)
	        notif = Notification.find_by_id(@id)
	        if (!notif)
	          codeAnswer 502
	          return
	        end
	        @returnValue = { content: notif.as_json(:include => :user) }
	        codeAnswer 200
  	    else
  	    	codeAnswer 500
  	    end
      rescue
        codeAnswer 504
      end
      sendJson
    end

    # Save a new object Notification. For more information on the parameters, check at the model
    # 
    # ==== Options
    # 
    # * +:notification[user_id]+ - Id of the user who has the notification
    # * +:notification[link]+ - The link where the notification redirect without the http://dns.com (to be usefull by the smartphone applications)
    # * +:notification[description]+ - The text of the notification
    # 
    def save
      begin
        if (@security)
          notif = Notification.new(@notification)
          if (notif.save)
            @returnValue = { content: notif.as_json(:include => :user) }
            codeAnswer 201
          else
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

    # Give a part of the notifications depending of the filter passed into parameter
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
    #     http://api.soonzik.com/notifications/find?attribute[user_id]=1&order_by_desc[]=user_id&group_by[]=user_id
    #     Note : By default, if you precise no attribute, it will take every row
    #
    def find
      begin
        if (!@security)
          codeAnswer 500
        else
          if (defined?@attribute)
            notification_object = nil
            # - - - - - - - -
            @attribute.each do |x, y|
              condition = ""
              if (y[0] == "%" && y[-1] == "%")  #LIKE
                condition = ["'notifications'.? LIKE ?", %Q[#{x}], "%#{y[1...-1]}%"];
              else                              #WHERE
                condition = {x => y};
              end

              if (notification_object == nil)          #notification_object doesn't exist
                notification_object = Notification.where(condition)
              else                              #notification_object exists
                notification_object = notification_object.where(condition)
              end
            end
            # - - - - - - - -
          else
            notification_object = Notification.all            #no attribute specified
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
            notification_object = notification_object.order(order_asc + ", " + order_desc)
          elsif (order_asc.size == 0 && order_desc.size > 0)
            notification_object = notification_object.order(order_desc)
          elsif (order_asc.size > 0 && order_desc.size == 0)
            notification_object = notification_object.order(order_asc)
          end

          if (defined?@group_by)    #group
            group = []
            @group_by.each do |x|
              group << %Q[#{x}]
            end
            notification_object = notification_object.group(group.join(", "))
          end

          if (defined?@limit)       #limit
            notification_object = notification_object.limit(@limit.to_i)
          end
          if (defined?@offset)      #offset
            notification_object = notification_object.offset(@offset.to_i)
          end

          @returnValue = { content: notification_object.as_json(:include => :user) }

          if (notification_object.size == 0)
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

    # Destroy a specific object by its id
    #
    # ==== Options
    # 
    # * +:id+ - The id of the specific notification
    # 
    def destroy
      begin
        if (@security)
          object = Notification.find_by_id(@id);
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
  end
end
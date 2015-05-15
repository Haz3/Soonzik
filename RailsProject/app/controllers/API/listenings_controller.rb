module API
  # Controller which manage the transaction for the Listenings objects
  # Here is the list of action available :
  #
  # * index       [get]
  # * show        [get]
  # * find        [get]
  # * save        [post] - SECURITY
  #
  class ListeningsController < ApisecurityController
    before_action :checkKey, only: [:save]

  	# Retrieve all the listenings
    #
    # Route : /listenings
    #
    # ==== Options
    # 
    # * +count+ - (optionnal) Get the number of object and not the object themselve. Useful for pagination
    #
    # ===== HTTP VALUE
    # 
    # - +200+ - In case of success, return a list of listening object including its user and music
    # - +503+ - Error from server
    # 
    def index
      begin
        if (defined? @count && @count == "true")
          @returnValue = { content: Listening.count }
        else
          @returnValue = { content: Listening.all.as_json(:include => {
                                                                      :user => { :only => User.miniKey },
                                                                      :music => { :only => Music.miniKey }
                                                                    }, :only => Listening.miniKey) }
        end
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
    # Route : /listenings/:id
    #
    # ==== Options
    # 
    # * +id+ - The id of the specific listening
    # 
    # ===== HTTP VALUE
    # 
    # - +200+ - In case of success, return a listening object including its user and music
    # - +404+ - Can't get the listening object, the is is probably wrong
    # - +503+ - Error from server
    # 
    def show
      begin
        listening = Listening.find_by_id(@id)
        if (!listening)
          codeAnswer 502
          defineHttp :not_found
        else
          @returnValue = { content: listening.as_json(:include => {
                                                                    :user => { :only => User.miniKey },
                                                                    :music => { :only => Music.miniKey }
                                                                  }, :only => Listening.miniKey) }
          codeAnswer 200
        end
      rescue
        codeAnswer 504
        defineHttp :service_unavailable
      end
      sendJson
    end

    # Give a part of the listening depending of the filter passed into parameter
    #
    # Route : /listenings/find
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
    #     http://api.soonzik.com/listenings/find?attribute[latitude]=1&order_by_desc[]=longitude&group_by[]=longitude
    #     Note : By default, if you precise no attribute, it will take every row
    #
    # ===== HTTP VALUE
    # 
    # - +200+ - In case of success, return a list of listening object including its user and music
    # - +503+ - Error from server
    # 
    def find
      begin
        listening_object = nil
        if (defined?@attribute)
          # - - - - - - - -
          @attribute.each do |x, y|
            condition = ""
            if (y[0] == "%" && y[-1] == "%")  #LIKE
              condition = ["'listenings'.? LIKE ?", %Q[#{x}], "%#{y[1...-1]}%"];
            else                              #WHERE
              condition = {x => y};
            end

            if (listening_object == nil)          #listening_object doesn't exist
              listening_object = Listening.where(condition)
            else                              #listening_object exists
              listening_object = listening_object.where(condition)
            end
          end
          # - - - - - - - -
        else
          listening_object = Listening.all            #no attribute specified
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
          listening_object = listening_object.order(order_asc + ", " + order_desc)
        elsif (order_asc.size == 0 && order_desc.size > 0)
          listening_object = listening_object.order(order_desc)
        elsif (order_asc.size > 0 && order_desc.size == 0)
          listening_object = listening_object.order(order_asc)
        end

        if (defined?@group_by)    #group
          group = []
          @group_by.each do |x|
            group << %Q[#{x}]
          end
          listening_object = listening_object.group(group.join(", "))
        end

        if (defined?@limit)       #limit
          listening_object = listening_object.limit(@limit.to_i)
        end
        if (defined?@offset)      #offset
          listening_object = listening_object.offset(@offset.to_i)
        end

        @returnValue = { content: listening_object.as_json(:include => {
                                                                          :user => { :only => User.miniKey },
                                                                          :music => { :only => Music.miniKey }
                                                                        }, :only => Listening.miniKey) }

        if (listening_object.size == 0)
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

    # Save a new object Listening. For more information on the parameters, check at the model
    #
    # Route : /listenings/save
    #
    # ==== Options
    # 
    # * +listening [music_id]+ - Id of the music listen
    # * +listening [latitude]+ - Position where the music has been listen
    # * +listening [longitude]+ - Position where the music has been listen
    # * +listening [when]+ - When the music has been listen
    # 
    # ===== HTTP VALUE
    # 
    # - +201+ - In case of success, return the new object
    # - +503+ - Error from server
    # 
    def save
      begin
        if (@security)
          @listening[:user_id] = @user_id
          listening = Listening.new(Listening.listening_params params)
          if (listening.save)
            @returnValue = { content: listening.as_json(:include => {
                                                                      :user => { :only => User.miniKey },
                                                                      :music => { :only => Music.miniKey }
                                                                    }, :only => Listening.miniKey) }
            codeAnswer 201
            defineHttp :created
          else
            @returnValue = { content: listening.errors.to_hash.to_json }
            codeAnswer 503
            defineHttp :service_unavailable
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
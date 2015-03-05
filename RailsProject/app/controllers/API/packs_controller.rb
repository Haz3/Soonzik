module API
  # Controller which manage the transaction for the Packs objects
  # Here is the list of action available :
  #
  # * index       [get]
  # * show        [get]
  # * find        [get]
  #
  class PacksController < ApisecurityController
    # Retrieve all the packs
    def index
      begin
        @returnValue = { content: Pack.all.as_json(:include => { albums: {
                                                                :include => { musics: { :only => Music.miniKey }},
                                                                :only => Album.miniKey
                                                              }}) }
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
    # * +:id+ - The id of the specific pack
    # 
    def show
      begin
        pack = Pack.find_by_id(@id)
        if (!pack)
          codeAnswer 502
        else
          @returnValue = { content: pack.as_json(:include => { albums: {
                                                                :include => { musics: { :only => Music.miniKey }},
                                                                :only => Album.miniKey
                                                              }}) }
          codeAnswer 200
        end
      rescue
        codeAnswer 504
      end
      sendJson
    end

    # Give a part of the packs depending of the filter passed into parameter
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
    #     http://api.soonzik.com/packs/find?attribute[style]=rock&order_by_desc[]=id&group_by[]=title
    #     Note : By default, if you precise no attribute, it will take every row
    #
    def find
      begin
        pack_object = nil
        if (defined?@attribute)
          # - - - - - - - -
          @attribute.each do |x, y|
            condition = ""
            if (y[0] == "%" && y[-1] == "%")  #LIKE
              condition = ["'packs'.? LIKE ?", %Q[#{x}], "%#{y[1...-1]}%"];
            else                              #WHERE
              condition = {x => y};
            end

            if (pack_object == nil)          #pack_object doesn't exist
              pack_object = Pack.where(condition)
            else                              #pack_object exists
              pack_object = pack_object.where(condition)
            end
          end
          # - - - - - - - -
        else
          pack_object = Pack.all            #no attribute specified
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
          pack_object = pack_object.order(order_asc + ", " + order_desc)
        elsif (order_asc.size == 0 && order_desc.size > 0)
          pack_object = pack_object.order(order_desc)
        elsif (order_asc.size > 0 && order_desc.size == 0)
          pack_object = pack_object.order(order_asc)
        end

        if (defined?@group_by)    #group
          group = []
          @group_by.each do |x|
            group << %Q[#{x}]
          end
          pack_object = pack_object.group(group.join(", "))
        end

        if (defined?@limit)       #limit
          pack_object = pack_object.limit(@limit.to_i)
        end
        if (defined?@offset)      #offset
          pack_object = pack_object.offset(@offset.to_i)
        end

        @returnValue = { content: pack_object.as_json(:include => { albums: {
                                                                :include => { musics: { :only => Music.miniKey }},
                                                                :only => Album.miniKey
                                                              }}) }

        if (pack_object.size == 0)
          codeAnswer 202
        else
          codeAnswer 200
        end

      rescue
        codeAnswer 504
      end
      sendJson
    end
  end
end
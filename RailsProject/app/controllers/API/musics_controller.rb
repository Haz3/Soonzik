module API
  # Controller which manage the transaction for the Musics objects
  # Here is the list of action available :
  #
  # * index       [get]
  # * show        [get]
  # * find        [get]
  # * addcomment  [post]
  # * get		  [get]
  #
  class MusicsController < ApisecurityController
  	before_action :checkKey, only: [:addcomment, :get]

    # Retrieve all the musics
    def index
      begin
        @returnValue = { content: Music.all.as_json }
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
    # * +:id+ - The id of the specific music
    # 
    def show
      begin
        album = Music.find_by_id(@id)
        if (!album)
          codeAnswer 502
          return
        end
        @returnValue = { content: album.as_json(:include => :album) }
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
    #     http://api.soonzik.com/musics/find?attribute[album_id]=1&order_by_desc[]=id&group_by[]=title
    #     Note : By default, if you precise no attribute, it will take every row
    #
    def find
      begin
        if (defined?@attribute)
          music_object = nil
          # - - - - - - - -
          @attribute.each do |x, y|
            condition = ""
            if (y[0] == "%" && y[-1] == "%")  #LIKE
              condition = ["'musics'.? LIKE ?", %Q[#{x}], "%#{y[1...-1]}%"];
            else                              #WHERE
              condition = {x => y};
            end

            if (music_object == nil)          #music_object doesn't exist
              music_object = Music.where(condition)
            else                              #music_object exists
              music_object = music_object.where(condition)
            end
          end
          # - - - - - - - -
        else
          music_object = Music.all            #no attribute specified
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
          music_object = music_object.order(order_asc + ", " + order_desc)
        elsif (order_asc.size == 0 && order_desc.size > 0)
          music_object = music_object.order(order_desc)
        elsif (order_asc.size > 0 && order_desc.size == 0)
          music_object = music_object.order(order_asc)
        end

        if (defined?@group_by)    #group
          group = []
          @group_by.each do |x|
            group << %Q[#{x}]
          end
          music_object = music_object.group(group.join(", "))
        end

        if (defined?@limit)       #limit
          music_object = music_object.limit(@limit.to_i)
        end
        if (defined?@offset)      #offset
          music_object = music_object.offset(@offset.to_i)
        end

        @returnValue = { content: music_object.as_json(:include => :album) }

        if (music_object.size == 0)
          codeAnswer 202
        else
          codeAnswer 200
        end

      rescue
        codeAnswer 504
      end
      sendJson
    end

    # Add a comment to a specific music. Need to be a secure transaction.
    #
    # ==== Options
    #
    # * +:security+ - If it's a secure transaction, this variable from ApiSecurity (the parent) is true
    # * +:id+ - The id of the music where is the comment
    # * +:content+ - The content of the comment
    #
  	def addcomment
      begin
        if (@security)
          music = Music.find_by_id(@id)

          if (!music)
            codeAnswer 502
            return
          end
          
          com = Commentary.new
          com.content = @content
          com.author_id = @user_id
          
          if (com.save)
            com.musics << music
            codeAnswer 201
          else
            codeAnswer 503
          end
        end
      rescue
        codeAnswer 504
      end
      sendJson
  	end
  end
end
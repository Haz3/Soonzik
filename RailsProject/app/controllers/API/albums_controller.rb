module API
  # Controller which manage the transaction for the Albums objects
  # Here is the list of action available :
  #
  # * index       [get]
  # * show        [get]
  # * find        [get]
  # * addcomment  [post] - SECURITY
  # * getcomments [get]
  #
  class AlbumsController < ApisecurityController
  	before_action :checkKey, only: [:addcomment]

    #
    # Retrieve all the albums
    #
    # Route : /albums
    #
    # ==== Options
    # 
    # * +count+ - (optionnal) Get the number of object and not the object themselve. Useful for pagination
    #
    # ===== HTTP VALUE
    # 
    # - +200+ - In case of success, return a list of albums including its music and the artist
    # - +503+ - Error from server
    # 
    def index
      begin
        if (@count.present? && @count == "true")
          @returnValue = { content: Album.count }
        else
          @returnValue = { content: Album.all.as_json(:only => Album.miniKey, :include => {
                                                                                :user => { :only => User.miniKey },
                                                                                :musics => { :only => Music.miniKey }
                                                                                } ) }
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
    # Route : /albums/:id
    #
    # ==== Options
    # 
    # * +:id+ - The id of the specific album
    # 
    # ===== HTTP VALUE
    # 
    # - +200+ - In case of success, return the album including its music and the artist
    # - +404+ - Can't get the album, the id is probably wrong
    # - +503+ - Error from server
    # 
    def show
      begin
        album = Album.find_by_id(@id)
        if (!album)
          codeAnswer 502
          defineHttp :not_found
        else
          @returnValue = { content: album.as_json(:only => Album.miniKey, :include => {
                                                              :musics => { :only => Music.miniKey},
                                                              :user => {:only => User.miniKey}
                                                              }) }
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
    # Route : /albums/find
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
    #     http://api.soonzik.com/albums/find?attribute[style]=rock&order_by_desc[]=id&group_by[]=yearProd
    #     Note : By default, if you precise no attribute, it will take every row
    #
    # ===== HTTP VALUE
    # 
    # - +200+ - In case of success, return a list of albums including its music and the artist
    # - +503+ - Error from server
    # 
    def find
      begin
        album_object = nil
        if (defined?@attribute)
          # - - - - - - - -
          @attribute.each do |x, y|
            condition = ""
            if (y[0] == "%" && y[-1] == "%")  #LIKE
              condition = ["'albums'.? LIKE ?", %Q[#{x}], "%#{y[1...-1]}%"];
            else                              #WHERE
              condition = {x => y};
            end

            if (album_object == nil)          #album_object doesn't exist
              album_object = Album.where(condition)
            else                              #album_object exists
              album_object = album_object.where(condition)
            end
          end
          # - - - - - - - -
        else
          album_object = Album.all            #no attribute specified
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
          album_object = album_object.order(order_asc + ", " + order_desc)
        elsif (order_asc.size == 0 && order_desc.size > 0)
          album_object = album_object.order(order_desc)
        elsif (order_asc.size > 0 && order_desc.size == 0)
          album_object = album_object.order(order_asc)
        end

        if (defined?@group_by)    #group
          group = []
          @group_by.each do |x|
            group << %Q[#{x}]
          end
          album_object = album_object.group(group.join(", "))
        end

        if (defined?@limit)       #limit
          album_object = album_object.limit(@limit.to_i)
        end
        if (defined?@offset)      #offset
          album_object = album_object.offset(@offset.to_i)
        end

        @returnValue = { content: album_object.as_json(:only => Album.miniKey, :include => {
                                                                      :musics => {:only => Music.miniKey },
                                                                      :user => {:only => User.miniKey}
                                                                    }) }

        if (album_object.size == 0)
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

    # Add a comment to a specific album. Need to be a secure transaction.
    #
    # Route : /albums/addcomment/:id 
    #
    # ==== Options
    #
    # * +:security+ - If it's a secure transaction, this variable from ApiSecurity (the parent) is true
    # * +:id+ - The id of the album where is the comment
    # * +:content+ - The content of the comment
    #
    # ===== HTTP VALUE
    # 
    # - +201+ - In case of success, return nothing
    # - +403+ - It is not a secured transaction
    # - +404+ - Can't get the album, the id is probably wrong
    # - +503+ - Error from server
    # 
  	def addcomment
      begin
        if (@security)
          album = Album.find_by_id(@id)

          if (!album)
            codeAnswer 502
            defineHttp :not_found
          else
            com = Commentary.new
            com.content = @content
            com.author_id = @user_id
            
            if (com.save)
              com.albums << album
              codeAnswer 201
              defineHttp :created
            else
              codeAnswer 503
              defineHttp :service_unavailable
            end
          end
        else
          defineHttp :forbidden
        end
      rescue
        codeAnswer 504
        defineHttp :service_unavailable
      end
      sendJson
  	end

    # Get comments of a specific albums.
    #
    # Route : /albums/:id/comments
    #
    # ==== Options
    #
    # * +:id+ - The id of the albums where is the comment
    # * +:offset+ - The offset of the comment array (default : 0)
    # * +:limit+ - The max size of the array (default : 20)
    #
    # ===== HTTP VALUE
    # 
    # - +200+ - In case of success, return the array of comment
    # - +404+ - Can't find the news, the id is probably wrong
    # - +503+ - Error from server
    # 
    def getcomments
      begin
        albums = Album.find_by_id(@id)
        @offset = 0 if !@offset.present?
        @limit = 20 if !@limit.present?
        if (!albums)
          codeAnswer 502
          defineHttp :not_found
        else
          comments = albums.commentaries[(@offset.to_i)..(@offset.to_i + @limit.to_i)] || []
          refine_comments = []
          comments.each { |comment|
            refine_comments << comment.as_json(:only => Commentary.miniKey)
          }
          @returnValue = { content: refine_comments }
        end
      rescue
        codeAnswer 504
        defineHttp :service_unavailable
      end
      sendJson
    end
  end
end
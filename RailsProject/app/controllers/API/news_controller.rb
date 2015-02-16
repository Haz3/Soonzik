module API
  # Controller which manage the transaction for the News objects
  # Here is the list of action available :
  #
  # * index       [get]
  # * show        [get]
  # * find        [get]
  # * addcomment  [post]
  #
  class NewsController < ApisecurityController
    before_action :checkKey, only: [:addcomment]

  	# Retrieve all the news
    def index
      begin
        @returnValue = { content: News.all.as_json(:include => { :user => {}, :newstexts => {}, :attachments => {}, :tags => {}}) }
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
    # * +:id+ - The id of the specific news
    # 
    def show
      begin
        news = News.find_by_id(@id)
        if (!news)
          codeAnswer 502
        else
          @returnValue = { content: news.as_json(:include => { :user => {}, :newstexts => {}, :attachments => {}, :tags => {}}) }
          codeAnswer 200
        end
      rescue
        codeAnswer 504
      end
      sendJson
    end

    # Give a part of the news depending of the filter passed into parameter
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
    #     http://api.soonzik.com/news/find?attribute[type]=1&order_by_desc[]=date&group_by[]=date
    #     Note : By default, if you precise no attribute, it will take every row
    #
    def find
      begin
        new_object = nil
        if (defined?@attribute)
          # - - - - - - - -
          @attribute.each do |x, y|
            condition = ""
            if (y[0] == "%" && y[-1] == "%")  #LIKE
              condition = ["'news'.? LIKE ?", %Q[#{x}], "%#{y[1...-1]}%"];
            else                              #WHERE
              condition = {x => y};
            end

            if (new_object == nil)          #new_object doesn't exist
              new_object = News.where(condition)
            else                              #new_object exists
              new_object = new_object.where(condition)
            end
          end
          # - - - - - - - -
        else
          new_object = News.all            #no attribute specified
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
          new_object = new_object.order(order_asc + ", " + order_desc)
        elsif (order_asc.size == 0 && order_desc.size > 0)
          new_object = new_object.order(order_desc)
        elsif (order_asc.size > 0 && order_desc.size == 0)
          new_object = new_object.order(order_asc)
        end

        if (defined?@group_by)    #group
          group = []
          @group_by.each do |x|
            group << %Q[#{x}]
          end
          new_object = new_object.group(group.join(", "))
        end

        if (defined?@limit)       #limit
          new_object = new_object.limit(@limit.to_i)
        end
        if (defined?@offset)      #offset
          new_object = new_object.offset(@offset.to_i)
        end

        @returnValue = { content: new_object.as_json(:include => { :user => {}, :newstexts => {}, :attachments => {}, :tags => {}}) }

        if (new_object.size == 0)
          codeAnswer 202
        else
          codeAnswer 200
        end

      rescue
        codeAnswer 504
      end
      sendJson
    end

    # Add a comment to a specific news. Need to be a secure transaction.
    #
    # ==== Options
    #
    # * +:security+ - If it's a secure transaction, this variable from ApiSecurity (the parent) is true
    # * +:id+ - The id of the news where is the comment
    # * +:content+ - The content of the comment
    #
    def addcomment
      begin
        if (@security)
          news = News.find_by_id(@id)

          if (!news)
            codeAnswer 502
          else
            com = Commentary.new
            com.content = @content
            com.author_id = @user_id
            
            if (com.save)
              com.news << news
              codeAnswer 201
            else
              codeAnswer 503
            end
          end
        end
      rescue
        codeAnswer 504
      end
      sendJson
    end
  end
end
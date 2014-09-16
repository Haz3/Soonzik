module API
  class NewsController < ApisecurityController
  	#index show find addcomment

  	# Retrieve all the news
    def index
      begin
        @returnValue = { content: News.all.as_json(:include => :newstexts) }
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
          return
        end
        @returnValue = { content: news.as_json(:include => :newstexts) }
        codeAnswer 200
      rescue
        codeAnswer 504
      end
      sendJson
    end
  end
end
class NewsController < ApplicationController
	before_action :set_news, only: [:show]

  # GET /news/:id.:format
  def index
  	@news = News.all
  end

  # GET /news/.:format
  def show
  end

  private
    def set_user
      @news = News.find(params[:id])
    end
end
end

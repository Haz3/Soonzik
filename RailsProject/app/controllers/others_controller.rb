class OthersController < ApplicationController
  include FormatsHelper

  def index
  	@user = session[:u]
  end
end
class RegistrationsController < Devise::RegistrationsController
  def new
  	puts params
  end

  def update
  	puts params
  end
end
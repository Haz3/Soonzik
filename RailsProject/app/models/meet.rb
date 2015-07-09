# The model of the object Meet
class Meet < ActiveRecord::Base
	belongs_to :user

  # The strong parameters to save or update object
  def self.meet_params(parameters)
    parameters.require(:meet).permit(:location, :query, :profession, :what, :fromDate, :toDate, :email)
  end
end

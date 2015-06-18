# The model of the object Identity
# Contain the relation and the validation
# Can provide some features linked to this model
#
# This model is used for social network connection.
# The salt that the smartphone application need to use for the login thanks to social network is :
# "3uNi@rCK$L$om40dNnhX)#jV2$40wwbr_bAK99%E"
#
# ==== Attributes
#
# - +id+ - (integer) - The ID of the object
# - +name+ - (string) - The name of the group
#
# ==== Associations
#
# - +has_many+ - :accesses (Not sure if we will keep it)
# - +has_and_belongs_to_many+ - :users
#
class Identity < ActiveRecord::Base
	before_validation :newToken, on: :create

  belongs_to :user
  validates_presence_of :uid, :provider, :token
  validates_uniqueness_of :uid, :scope => :provider

  SALT = "3uNi@rCK$L$om40dNnhX)#jV2$40wwbr_bAK99%E"

  # Find or create an user by the oauth value
  def self.find_for_oauth(auth)
    find_or_create_by(uid: auth.uid, provider: auth.provider)
  end

  # Create a new token
  def newToken
  	key = nil
  	begin
      key = Identity.tokenGenerator
    end while (Identity.find_by_token(key))
    self.token = key
  end

  # Return a new random token
  def self.tokenGenerator
		sha256 = Digest::SHA1.new

    key = ""
    example = ('a'..'z').to_a.concat(('A'..'Z').to_a.concat(('0'..'9').to_a)).shuffle[0,48].join
    48.times do
      key += example[Random.rand(example.size)]
    end

    return sha256.hexdigest key
 	end
end

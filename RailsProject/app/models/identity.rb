class Identity < ActiveRecord::Base
	before_validation :newToken, on: :create

  belongs_to :user
  validates_presence_of :uid, :provider, :token
  validates_uniqueness_of :uid, :scope => :provider

  def self.find_for_oauth(auth)
    find_or_create_by(uid: auth.uid, provider: auth.provider)
  end

  def newToken
  	key = nil
  	begin
      key = Identity.tokenGenerator
    end while (Identity.find_by_token(key))
    self.token = key
  end

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
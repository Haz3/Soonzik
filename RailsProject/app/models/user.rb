# The model of the object User
# Contain the relation and the validation
# Can provide some features linked to this model
class User < ActiveRecord::Base
  belongs_to :address

  has_one :cart

  has_many :albums
  has_many :listening
  has_many :notifications
  has_many :news
  has_many :propositions
  has_many :tweets
  has_many :votes
  has_many :purchases

  has_many :gifts_given, class_name: 'Gift', foreign_key: 'from_user'
  has_many :gifts_received, class_name: 'Gift', foreign_key: 'from_user'
  has_many :battles_one, class_name: 'Battle', foreign_key: 'artist_one_id'
  has_many :battles_two, class_name: 'Battle', foreign_key: 'artist_two_id'
  has_many :messages_sender, class_name: 'Message', foreign_key: 'user_id'
  has_many :messages_receiver, class_name: 'Message', foreign_key: 'dest_id'

  has_and_belongs_to_many :groups
  has_and_belongs_to_many :follows, class_name: 'User', foreign_key: 'user_id', join_table: 'follows'
  has_and_belongs_to_many :followers, class_name: 'User', foreign_key: 'follow_id', join_table: 'follows'
  has_and_belongs_to_many :friends, class_name: 'User', foreign_key: 'user_id', join_table: 'friends'
  has_and_belongs_to_many :friends_with, class_name: 'User', foreign_key: 'friend_id', join_table: 'friends'

  # validation
  # message: 'the message'
  validates :email, confirmation: true, format: /\b[A-Z0-9._%a-z\-]+@(?:[A-Z0-9a-z\-]+\.)+[A-Za-z]{2,4}\z/  #if doesn't work : /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  validates :password, confirmation: true, length: { is: 32 }
  validates :terms_of_service, acceptance: true
  validates :username, length: {
    minimum: 4,
    maximum: 20,
    too_short: "must have at least %{count} words",
    too_long: "must have at most %{count} words"
  }
  validates :idAPI, length: { is: 40 }
  validates :secureKey, length: { is: 40 }
  validates :salt, length: { is: 40 }
  validates :groups, :email, :password, :salt, :username, :birthday, :image, :signin, :idAPI, :secureKey, :activated, :newsletter, :language, presence: true
  validates :email, :username, uniqueness: true
  validates :birthday, format: /(\d{4})-(\d{2})-(\d{2}) (\d{2}):(\d{2}):(\d{2})/
  
  before_create do |user|
    user.salt = self.salt_hash(user.password)
    user.password = User.password_hash(user.password)
    user.image = "default.png" if user.image == nil || (user.image != nil && user.image == "")
    user.activated = false
    user.newsletter = true if user.newsletter == nil
    user.regenerateKey
  end

  # Recreate an idAPI and so the secureKey associated
  # The secureKey need to be unique so we check if someone already has this one
  def regenerateKey
    key = nil

    begin
      key = User.secureKey_hash(self.createKey())
    end while (User.find_by_idAPI(key))

    self.idAPI = key
    self.secureKey = generateHash(self.salt, key)
    self.save
  end

  # Static function to create the hash of the secureKey
  #
  # ==== Attributes
  #
  # * +key+ - The generated key to encode
  #
  def self.secureKey_hash(key)
    Digest::SHA1.hexdigest(Digest::MD5.hexdigest(key))
  end

  # Static function to create the hash of the password
  #
  # ==== Attributes
  #
  # * +pass+ - The password of the user to encode
  #
  def self.password_hash(pass)
    Digest::MD5.hexdigest(Digest::SHA1.hexdigest(pass))
  end

  # Static function to create the hash of the salt
  # It uses the password, so it has to be set before
  def salt_hash
    User.secureKey_hash("#{Digest::SHA256.hexdigest("#{Time.now.utc}--#{self.password}")}--#{Digest::SHA256.hexdigest(self.password)}")
  end

  ########

  private

  # Private function to create a random key of 48 characters
  def createKey
    sha256 = Digest::SHA1.new

    key = ""
    example = ('a'..'z').to_a.concat(('A'..'Z').to_a.concat(('0'..'9').to_a)).shuffle[0,48].join
    48.times do
      key += example[Random.rand(example.size)]
    end

    return sha256.hexdigest key
  end

  # Create a hash by addition of two values considered as string
  def generateHash(value1, value2)
    sha256 = Digest::SHA1.new
    return sha256.hexdigest(value1.to_s + value2.to_s)
  end
end

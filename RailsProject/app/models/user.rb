# The model of the object User
# Contain the relation and the validation
# Can provide some features linked to this model
class User < ActiveRecord::Base
  before_validation :beforeCreate, on: :create

  attr_accessor :flash

  TEMP_EMAIL_PREFIX = 'change@me'
  TEMP_EMAIL_REGEX = /\Achange@me/
  TEMP_USERNAME_PREFIX = 'change-me'
  TEMP_USERNAME_REGEX = /\Achange-me/

  # Include default devise modules. Others available are:
  # :lockable, :timeoutable
  devise :database_authenticatable, :registerable, :confirmable,
    :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  belongs_to :address

  has_one :cart

  has_many :albums
  has_many :identities
  has_many :listening
  has_many :notifications
  has_many :news
  has_many :propositions
  has_many :tweets
  has_many :votes
  has_many :purchases
  has_many :purchased_musics, through: :purchases, source: :musics
  has_many :commentaries, foreign_key: 'author_id'

  has_many :gifts_given, class_name: 'Gift', foreign_key: 'from_user'
  has_many :gifts_received, class_name: 'Gift', foreign_key: 'from_user'
  has_many :battles_one, class_name: 'Battle', foreign_key: 'artist_one_id'
  has_many :battles_two, class_name: 'Battle', foreign_key: 'artist_two_id'
  has_many :messages_sender, class_name: 'Message', foreign_key: 'user_id'
  has_many :messages_receiver, class_name: 'Message', foreign_key: 'dest_id'

  has_and_belongs_to_many :groups

  #FOLLOW TRICKS
  has_many :relations_follow, :foreign_key => 'user_id', :class_name => 'Follow'
  has_many :relations_follower, :foreign_key => 'follow_id', :class_name => 'Follow'
  has_many :follows, :through => :relations_follow, :source => :user_to
  has_many :followers, :through => :relations_follower, :source => :user
  
  has_many :relations_friend, :foreign_key => 'user_id', :class_name => 'Friend'
  has_many :relations_friendly, :foreign_key => 'friend_id', :class_name => 'Friend'
  has_many :friends, :through => :relations_friend, :source => :user_to
  has_many :frienders, :through => :relations_friendly, :source => :user
  
  # validation
  # message: 'the message'
  #validates :email, confirmation: true, format: /\b[A-Z0-9._%a-z\-]+@(?:[A-Z0-9a-z\-]+\.)+[A-Za-z]{2,4}\z/  #if doesn't work : /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  #validates :encrypted_password, confirmation: true, length: { is: 20 }
#  validates :terms_of_service, acceptance: true
  validates :username, length: {
    minimum: 3,
    maximum: 40,
    too_short: "must have at least %{count} letters",
    too_long: "must have at most %{count} letters"
  }
  validates :idAPI, length: { is: 40 }
  validates :secureKey, length: { is: 64 }
  validates :salt, length: { is: 40 }
  validates :email, :salt, :username, :fname, :lname, :birthday, :image, :idAPI, :secureKey, :language, presence: true
  validates :newsletter, :inclusion => { :in => [true, false] }
  validates :email, :username, uniqueness: true
  validates :birthday, format: /(\d{4})-(\d{2})-(\d{2})/
  validates :password, presence: true, on: :created

  validates_format_of :email, :without => TEMP_EMAIL_REGEX, on: :update
  validates_format_of :username, :without => TEMP_USERNAME_REGEX, on: :update


  # for OAuth interpretation
  def self.find_for_oauth(auth, signed_in_resource = nil)

    # Get the identity and user if they exist
    identity = Identity.find_for_oauth(auth)

    # If a signed_in_resource is provided it always overrides the existing user
    # to prevent the identity being locked with accidentally created accounts.
    # Note that this may leave zombie accounts (with no associated identity) which
    # can be cleaned up at a later date.
    user = signed_in_resource ? signed_in_resource : identity.user

    # Create the user if needed
    if user.nil?

      # Get the existing user by email if the provider gives us a verified email.
      # If no verified email was provided we assign a temporary email and ask the
      # user to verify it on the next step via UsersController.finish_signup
      email_is_verified = auth.info.email && (auth.info.verified || auth.info.verified_email || auth.extra.raw_info.email_verified)
      email = auth.info.email if email_is_verified
      user = User.where(:email => email).first if email

      # Create the user if it's a new registration
      if user.nil?
        user = User.new(
          username: "#{TEMP_USERNAME_PREFIX}-#{auth.extra.raw_info.name}",
          fname: (auth.extra.raw_info.first_name) ? auth.extra.raw_info.first_name : ((auth.extra.raw_info.given_name) ? auth.extra.raw_info.given_name : nil),
          lname: (auth.extra.raw_info.last_name) ? auth.extra.raw_info.last_name : ((auth.extra.raw_info.family_name) ? auth.extra.raw_info.family_name : nil),
          image: (auth.info.image) ? auth.info.image : nil,
          #username: auth.info.nickname || auth.uid,
          email: email ? email : "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com",
          password: Devise.friendly_token
        )
        user.skip_confirmation!
        if (!user.save)
          user.email = "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com" if user.errors[:email].any?
          user.username = "#{TEMP_USERNAME_PREFIX}-#{user.username}" if user.errors[:username].any?
          if (!user.save)
            user.errors.messages.each { |errorSym, errorValue|
              @flash[errorSym] = errorValue
            }
          end
        end
      end
      signed_in_resource = user
    end

    if signed_in_resource == nil && identity.user == user
      identity.newToken
      identity.save!
    end

    # Associate the identity with the user if needed
    if identity.user != user
      identity.user = user
      identity.save!
    end
    user
  end

  # Is there the default email address or not ?
  def email_verified?
    self.email && self.email !~ TEMP_EMAIL_REGEX
  end

  # Is there the default username or not ?
  def username_verified?
    self.username && self.username !~ TEMP_USERNAME_REGEX
  end

  # Recreate an idAPI and so the secureKey associated
  # The secureKey need to be unique so we check if someone already has this one
  def regenerateKey
    key = nil

    begin
      key = User.secureKey_hash(createKey())
    end while (User.find_by_idAPI(key))

    self.idAPI = key
    self.secureKey = generateHash(self.salt, key)
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

  # Method to create the hash of the salt
  # It uses the password, so it has to be set before
  def salt_hash
    first_piece = Digest::SHA256.hexdigest("#{Time.now.utc}--#{self.password}")
    second_piece = Digest::SHA256.hexdigest(self.password)
    User.secureKey_hash("#{first_piece}--#{second_piece}")
  end

  # The strong parameters to save or update object
  def self.user_params(parameters)
    parameters.require(:user).permit(:email, :password, :fname, :lname, :username, :birthday, :image, :description, :phoneNumber, :facebook, :twitter, :googlePlus, :newsletter, :language)
  end

  # Filter of information for the API - Restricted
  def self.miniKey
    [:id, :email, :username, :image, :description, :language]
  end

  # Filter of information for the API - Less Restricted
  def self.bigKey
    [:id, :email, :username, :fname, :lname, :birthday, :image, :description, :language, :facebook, :twitter, :googlePlus]
  end

  # Filter of information for the API - No Restriction
  def self.notRestrictedKey
    [:id, :email, :username, :fname, :lname, :birthday, :image, :description, :language, :facebook, :twitter, :googlePlus, :salt, :phoneNumber, :newsletter, :language, :created_at]
  end

  # Check is the user is an artist
  def isArtist?
    self.groups.each { |group|
      if (group.name == "Artist")
        return true
      end
    }
    return false
  end

  # Check if the user is a friend or not
  def hasFriend?(user)
    self.friends.each { |friend|
      if (friend.id == user.id)
        return true
      end
    }
    return false
  end

  # Give the 5 most popular track of an artist
  def giveTopFive
    allMusics = []

    self.albums.each { |album|
      album.musics.each { |music|
        allMusics << { note: music.getAverageNote, object: music }
      }
    }

    allMusics.sort! { |a,b| b[:note] <=> a[:note] }
    return allMusics[0..5]
  end

  # Give the pack where the user has its albums
  def givePack
    return Pack.joins(albums: [:user]).where(users: {id: self.id})
  end

  ########

  private

  # Private function to change elements before creation of a row
  def beforeCreate
    self.salt = self.salt_hash if defined?(self.password) && self.password != nil
    self.image = "default.png" if self.image == nil || (self.image != nil && self.image == "")
    self.newsletter = true if self.newsletter == nil
    self.regenerateKey() if defined?(self.password) && self.password != nil
    self.birthday = Time.new(1900,1,1).to_s(:db) if (self.birthday == nil)
    self.language = "EN" if (self.language == nil)
  end

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
    sha256 = Digest::SHA256.new
    return sha256.hexdigest(value1.to_s + value2.to_s)
  end
end

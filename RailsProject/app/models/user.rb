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

  #validation
  validates :email, confirmation: true, format: /\b[A-Z0-9._%a-z\-]+@(?:[A-Z0-9a-z\-]+\.)+[A-Za-z]{2,4}\z/
  validates :password, confirmation: true, length: { is: 40 }
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
  validates :birthday, format: /(19|20)\d\d[- /.](0[1-9]|1[012])[- /.](0[1-9]|[12][0-9]|3[01]) \d\d:\d\d:\d\d/
end

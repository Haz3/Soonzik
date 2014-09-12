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
end

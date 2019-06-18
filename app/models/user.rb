class User < ApplicationRecord
	has_many :photos
	has_many :comments
	has_many :follows

	has_many :follower_relationships, foreign_key: :following_id, class_name: 'Follow'
	has_many :followers, through: :follower_relationships, source: :follower
	has_many :following_relationships, foreign_key: :user_id, class_name: 'Follow'
	has_many :followings, through: :following_relationships, source: :follower

	validates :nickname, uniqueness: true
end

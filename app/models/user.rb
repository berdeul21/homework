class User < ApplicationRecord
	has_many :photos
	has_many :comments

	validates :nickname, uniqueness: true
end

class Photo < ApplicationRecord
	belongs_to :user
	has_many :collects
	has_many :comments, as: :commentable, dependent: :delete_all
	has_many :likes, as: :likeable, dependent: :delete_all
end

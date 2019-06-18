class Photo < ApplicationRecord
	belongs_to :user
	has_many :collects
	has_many :comments, as: :commentable, dependent: :delete_all
end

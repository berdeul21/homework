class Photo < ApplicationRecord
	belongs_to :user
	has_many :collects
end

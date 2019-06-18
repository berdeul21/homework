class Like < ApplicationRecord
	belongs_to :commentable, polymorphic: true
end

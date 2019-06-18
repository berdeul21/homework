class AddIndexToUsersAndPhotos < ActiveRecord::Migration[5.2]
  def change
    add_index :users, :nickname, unique: true
    add_index :photos, :category
  end
end

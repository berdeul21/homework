class CreateAlbums < ActiveRecord::Migration[5.2]
  def change
    create_table :albums do |t|
    	t.integer :user_id
    	t.text :summary

      t.timestamps
    end

    create_table :collects do |t|
    	t.integer :album_id
    	t.integer :photo_id
    	t.integer :seq
    	t.boolean :cover, default: false
    	
      t.timestamps
    end
  end
end

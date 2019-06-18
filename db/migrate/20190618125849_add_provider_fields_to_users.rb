class AddProviderFieldsToUsers < ActiveRecord::Migration[5.2]
  def change
  	add_column :users, :provider, :string
  	add_column :users, :provider_id, :string
  end
end

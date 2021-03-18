class AddUserphotoToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users,:userimage,:string
  end
end

class AddColumsToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users,:usernickname,:string
    add_column :users,:username,:string
    add_column :users,:usersex,:boolean
    add_column :users,:userbirth,:date
    add_column :users,:userid,:string
    add_column :users,:usercollege,:string
    add_column :users,:userintro,:string
     
  end
end

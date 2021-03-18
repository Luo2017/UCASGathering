class ChangeColumnToSex < ActiveRecord::Migration[6.0]
  def change
    change_column :users,:usersex,:string
  end
end

class AddColumnsToVcode < ActiveRecord::Migration[6.0]
  def change
    add_column :users,:vcode,:string
  end
end

class AddPictureToActivities < ActiveRecord::Migration[6.0]
  def change
    add_column :activities, :picture, :string
  end
end

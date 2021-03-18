class CreateActivities < ActiveRecord::Migration[6.0]
  def change
    create_table :activities do |t|
      t.integer :UserId
      t.integer :AcId
      t.string :AcStatus
      t.string :AcClass
      t.string :AcTitle
      t.string :AcSitu
      t.datetime :AcStartTime
      t.datetime :AcEndTime
      t.integer :AcCount
      t.string :AcDura
      t.integer :AcIsPra
      t.string :AcPass
      t.text :AcIntro
      t.string :AcUsersGroup

      t.timestamps
    end

  end
end

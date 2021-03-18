class CreateRelationships < ActiveRecord::Migration[6.0]
  def change
    create_table :relationships do |t|
      t.integer :follower_user_id #用户id
      t.integer :followed_act_id #用户加入的活动id

      t.timestamps
    end
  end

  #添加索引以及联合索引,增加检索速度
  # add_index :relationships, :follower_user_id
  # add_index :relationships, :followed_act_id
  # add_index :relationships, [:follower_user_id, :followed_act_id],unique: true
end

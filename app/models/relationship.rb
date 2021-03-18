class Relationship < ApplicationRecord
    belongs_to :follower_user, class_name: "User"
    belongs_to :followed_act, class_name: "Activity"
    validates :follower_user_id, presence: true
    validates :followed_act_id,  presence: true
end

class User < ApplicationRecord
    has_secure_password
    #建立User与Relationship之间的关联，一个人可以加入多个活动，主动关系的外键为follower_user_id
    has_many :active_relationships, class_name: "Relationship",foreign_key: "follower_user_id"
    #可以使用following数组来获取当前用户加入的活动列表
    has_many :following, through: :active_relationships,source: :followed_act
    # 和活动建立一对多联系
    has_many :activities

    mount_uploader :userimage, UserimageUploader 
    validates :password, presence: true, length: { minimum: 6, maximum: 20 }
    validates :password_confirmation, presence: true, length: { minimum: 6, maximum: 20 }
    validates :usermobile, presence: true, length: { minimum: 3, maximum: 13 },uniqueness: true#手机号

    validates :usernickname, presence: true , length: { minimum: 1, maximum: 50 },uniqueness: { case_sensitive: false}#昵称   
    validates :username, presence: true , length: { minimum: 2, maximum: 50 }#真实姓名
    validates :usersex, presence: true #性别
    validates :userid, presence: true ,uniqueness: { case_sensitive: false}#学号


    validates :usercollege,  length: { minimum: 2, maximum: 50 }#学院
    validates :userintro,  length: {maximum: 100 }#个人简介

    #加入一个活动
    def follow(activity)
        self.active_relationships.create(followed_act_id: activity.id)
    end

    #退出一个活动
    def unfollow(activity)
        self.active_relationships.find_by(followed_act_id: activity.id).destroy
    end

    #判断当前用户是否加入了指定活动
    def following?(activity)
        self.following.include?(activity)
    end
    
end

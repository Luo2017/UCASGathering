class Activity < ApplicationRecord

    # 建立起与用户的联系，外键默认是user_id这种形式，手动设置为UserId
    belongs_to :user, class_name: "User", foreign_key: "UserId"
    validates :UserId, presence: {message: "用户id不能为空"}  #用户id
    # 在查找一堆活动时，默认按照创建时间倒序的方式展示
    default_scope -> {order(created_at: :desc)}

    validates :AcStatus, presence: {message: "活动状态不能为空"} #活动状态
    validates :AcClass, presence: {message: "活动类别不能为空"} #活动类别
    validates :AcTitle, presence: {message: "活动标题不能为空"}, length: {maximum: 50, message: "活动标题不能超过50个字符"} #活动标题
    validates :AcSitu, presence: {message: "地点不能为空"} #活动地点
    validates :AcStartTime, presence: {message: "活动开始时间不能为空"} #活动开始时间
    validates :AcEndTime, presence: {message: "活动截止时间不能为空"} #报名截止时间
    validates :AcCount, presence: {message: "报名人数不能为空"} #报名人数
    validates :AcDura, presence: {message: "活动时长不能为空"} #活动时长
    validates :AcIsPra, presence: {message: "未设置活动是否私密"} #活动是否私密
    # 私密活动密码允许为空，但只能是3位数字
    validates :AcPass, allow_blank: true, length: {is: 4, message: "密码应当设置为4位数字"}, 
        numericality: { only_integer: true, message: "密码只能是3位数字" } 
    validates :AcIntro, presence: {message: "活动简介不能为空"}, length: {maximum: 1000, message: "活动简介不能超过1000个字符"} #活动简介

    # 暂时未实现图片功能
    # # 使用mount_uploader方法把图片和模型关联起来
    mount_uploader :picture, PictureUploader
    validate  :picture_size

    # 验证图片上传的大小
    def picture_size
        puts "function==picture_size:#picture.size"
        # 如果图片大于5MB
        if picture.size>5.megabytes
            # 就向errors合集中添加一个自定义的消息
            errors.add(:picture,"should less than 5MB")
        end
    end
    
    has_many :passive_relationships, class_name: "Relationship",foreign_key: "followed_act_id"
    #可使用followers数组获取加入了当前活动的用户列表
    has_many :followers, through: :passive_relationships,source: :follower_user

    #判断指定用户是否加入了当前活动
    def followed?(user)
        self.followers.include?(user)
    end

    # 当活动为私密时，用该方法可以验证输入口令是否和@activity.AcPass密码匹配
    def correct_activity_password?(token)
        if self.AcIsPra == 1 && self.AcPass.to_i == token.to_i
            return true
        else
            return false
        end
    end

    # 用来显示活动图片的名称
    def show_picture_name
        name = self.picture.to_s.split("/")
        return name[-1]
    end 
    # 分类筛选多个条件组合筛选
    def self.like_any(fields, values)
        where fields.map { |field|
          values.map { |value|
            arel_table[field].matches("%#{value}%")
          }.inject(:or)
        }.inject(:or)
      end

    
end

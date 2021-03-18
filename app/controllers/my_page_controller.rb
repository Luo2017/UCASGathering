class MyPageController  < ApplicationController

  before_action :set_user, only: [:home, :showMyInfo, :showMyActivities, :showMyActivitiesJoined]
  # 出现csrf报错时的处理
  skip_before_action :verify_authenticity_token
  # 还要有logged_in_user的判断，限定在动作之前登录才行,在applicationcontroller中定义
  before_action :logged_in_user, only: [:home, :showMyActivities, :showMyInfo, :showMyActivitiesJoined]


  def home
    render 'my_pages/my_page'
  end

  def showMyActivities
    @pId= @cUser.id
    @activities = Activity.all
    render 'my_pages/my_activities'
  end

  def showMyInfo
    render 'my_pages/my_info'
  end

  def showMyActivitiesJoined
    @pId= @cUser.id
    @relationships = Relationship.all
    render 'my_pages/my_activities_joined'
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @cUser = current_user
      puts "***#{@cUser}"
    end

  end
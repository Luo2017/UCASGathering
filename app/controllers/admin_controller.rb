class AdminController < ApplicationController
  def show
    @users = User.all
  end

  def delete
    userid = params[:data][:userid]
    @user = User.find_by(userid: userid)
    @user.destroy
    respond_to do |format|
      format.html { redirect_to admin_show_path, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def update
    acid = params[:data][:activity].to_i
    @activity = Activity.find_by(AcId: acid)
  end

  def activityshow
    @activitys = Activity.all
  end

  def activity_allow
    id = params[:data][:activity].to_i
    puts id
    @activity = Activity.find_by(id: id)
    if @activity.AcStatus.to_i > 2
      #什么都不做
    else
      #@activity.AcStatus = @activity.AcStatus.to_i + 1
      #puts @activity.AcStatus
      @activity.update_attribute(:AcStatus, "1")
      respond_to do |format|
        format.html { redirect_to admin_activityshow_path }
        format.json { head :no_content }
      end

    end
  end


  def activity_fail
    id = params[:data][:activity].to_i
    @activity = Activity.find_by(id: id)
    if @activity.AcStatus.to_i > 2

      #什么都不做

    else
      #@activity.AcStatus = 2
      @activity.update_attribute(:AcStatus, "2")
      respond_to do |format|
        format.html { redirect_to admin_activityshow_path }
        format.json { head :no_content }
      end

    end
  end

  def personal
    @user = User.all[1]
  end

  def myActivity
    userid = params[:userid]
    @user = User.find_by(userid: userid)
    activitys = Activity.all
    @activity_list = []
    activitys.each do |activity|
      if group_include(activity, userid)
        @activity_list.append(activity)
      end
    end
  end

  def createMyActivity
    userid = params[:userid]
    @user = User.find_by(userid: userid)
    activitys = Activity.all
    puts activitys.size
    @activity_Mylist = []
    activitys.each do |activity|
      if group_belong(activity, userid)
        @activity_Mylist.append(activity)
      end
    end
  end

  #判断是否是我创建
  def group_belong(activity, userid)
    if activity[:UserId].to_i == userid.to_i
      return true
    end
    return false
  end

  #判断是否是我参加的
  def group_include(activity, userid)
    user_list = activity[:AcUsersGroup].split('+')
    user_list.each do |item|
      if item.to_i == userid.to_i
        return true
      end
    end
    return false
  end
end

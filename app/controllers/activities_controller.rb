require 'time'
class ActivitiesController < ApplicationController


  # 回调函数，在执行下面的4个方法时都会根据传值设定好@activity
  before_action :set_activity, only: [:show, :edit, :update, :destroy]
  # 出现csrf报错时的处理
  skip_before_action :verify_authenticity_token
  # 要判断是否是活动的拥有者或是管理员
  before_action :correct_user, only: [:show, :edit, :update, :destroy]
  # 还要有logged_in_user的判断，限定在动作之前登录才行
  before_action :logged_in_user, only: [:show, :edit, :update, :destroy, :create, :new]
  # 检查活动是否已经到了截止时间，如果是则活动终止，并且不可以再次编辑，显示相应内容
  before_action :check_time, only: [:show, :edit, :update]

  # GET /activities
  # GET /activities.json

  def index
    @activities = Activity.all
  end

  # GET /activities/1
  # GET /activities/1.json
 
  def show
  end

  # GET /activities/new
 
  def new
  end

  # GET /activities/1/edit

  def edit
    # 如果没有修改权限或者活动已经截止，却能执行到这里，则跳转到异常处理界面
    if @isCorrectUser == 0 || @activityIsEnded == 1 || @activity.AcStatus != "1"
      redirect_to nc_user_path
      return
    end
    # 将开始时间和截止时间显示在页面上
    # 数据库中datetime是2003-01-01 00:00:00 UCT的格式
    # 这里要把数据库中的格式转换成：2003-01-01T00:00:00的形式才能显示，使用实例变量传入视图
    tmp0=@activity.AcStartTime.to_s.split()
    @start_time=tmp0[0] + 'T' + tmp0[1]
    tmp1=@activity.AcEndTime.to_s.split()
    @end_time=tmp1[0] + 'T' + tmp1[1]
  end

  # POST /activities
  # POST /activities.json
  def create
    @activity = Activity.new(activity_params)
    # 这里应当考虑用current_user.activities.new()来创建活动
    user = current_user
    @activity.UserId = user.id # 这里应当改为当前用户id，目前以id为1的用户来进行测试
    @activity.AcStatus = "1" # 活动创建后即表示正在进行中，值为1
    puts "#{@activity.picture}"
    # 至于AcId可以考虑除去，因为使用的是id作为主键
    puts "#{@activity.UserId}"
    respond_to do |format|
      if @activity.save
        format.html { redirect_to @activity, notice: '活动创建成功！' }
        format.json { render :show, status: :created, location: @activity }
      else
        puts "!!创建失败，原因:#{@activity.errors.messages}"
        format.html { render 'shared/_error' }
        format.json { render json: @activity.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /activities/1
  # PATCH/PUT /activities/1.json
  # 修改时先经过edit动作，返回edit视图，将修改提交到此动作
  def update
    # 如果没有修改权限或者活动已经截止，却能执行到这里，则跳转到异常处理界面
    if @isCorrectUser == 0 || @activityIsEnded == 1|| @activity.AcStatus != "1"
      redirect_to nc_user_path
      return
    end
    # 每次更改后都要设置为正在进行
    activity_params_extends = activity_params
    activity_params_extends[:AcStatus] = "1"
    puts "!! activity_params = #{activity_params}"
    puts "!! activity_params_extends = #{activity_params_extends}"
    respond_to do |format|
      if @activity.update(activity_params_extends)
        format.html { redirect_to @activity, notice: '活动修改成功!' }
        format.json { render :show, status: :ok, location: @activity }
      else
        format.html { render 'shared/_error' }
        format.json { render json: @activity.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /activities/1
  # DELETE /activities/1.json
  # 删除后应当跳转到当前用户的活动列表页，并提示notice
  def destroy
    if @isCorrectUser == 0
      redirect_to nc_user_path
      return
    end
    @activity.destroy
    respond_to do |format|
      format.html { redirect_to root_url, notice: '活动删除成功！' }
      format.json { head :no_content }
    end
  end

  # 没有权限时错误警告
  def not_correct_user
    render 'shared/_nc_user_error'
  end

  # 活动不存在出错
  def ac_error_occured
    render 'shared/_ac_error'
  end

  def followers
    @title = "当前成员"
    #通过id查询活动，并检索该活动的followers列表
    @activity = Activity.find(params[:id])
    @users = @activity.followers.paginate(page: params[:page])
    render 'show_followers'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_activity
      find_id = params[:id]
      # 首先检查相应id的活动是否存在
      puts "#{find_id}"
      all_activities = Activity.all
      isFounded = 0
      all_activities.each do |a|
        if find_id.to_i == a.id.to_i
          isFounded = 1
        end
      end
      puts "---#{isFounded}"

      if isFounded == 0
        redirect_to ac_error_path
        return
      end

      @activity = Activity.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def activity_params
      params.require(:activity).permit(:UserId, :AcStatus, :AcClass, :AcTitle, :AcSitu, :AcStartTime, :AcEndTime, :AcCount, :AcDura, :AcIsPra, :AcPass, :AcIntro, :picture)
    end

    # 判断是否是活动拥有者或管理员
    def correct_user
      a = Activity.find(params[:id])
      # 有了current_user功能后可以使用,先设置为当前用户值为1
      user = current_user # 在application中已经include sessions_helper了
      puts "***当前用户的手机号为: #{user.usermobile}***"
      puts "***a.UserId为: #{a.UserId}***"
      puts "***user.id为: #{user.id}***"
      # @isCorrectUser = 1 
      if a.UserId.to_i == user.id.to_i
         @isCorrectUser = 1
      else
         @isCorrectUser =  0 # 因为show动作允许不是owner，所以不用设置异常页
      end
      puts "***@isCorrectUser = #{@isCorrectUser}***"
    end

    # 根据当前时间设置活动是否已经结束的状态
    def check_time
      ac = Activity.find(params[:id])
      puts "#{ac.AcStatus}"
      endTimeStr = ac.AcEndTime.strftime('%Y-%m-%d %H:%M:%S')
      puts "***endtime = #{ac.AcEndTime}, formatStr = #{endTimeStr}"
      nowTime = Time.now
      nowTimeFmtStr = nowTime.strftime('%Y-%m-%d %H:%M:%S')
      puts "当前时间为: #{nowTime}, formatStr = #{nowTimeFmtStr}"
      eTime = Time.parse(endTimeStr)
      nTime = Time.parse(nowTimeFmtStr)
      puts "eTime = #{eTime}, nTime = #{nTime}"
      # 活动已经结束则该值为1，否则为0
      if eTime <= nTime
        @activityIsEnded = 1
        # 设置活动状态结束 3
        ac.update_attribute(:AcStatus, "3")
      else
        @activityIsEnded = 0
      end
      puts "ended? #{@activityIsEnded},status = #{ac.AcStatus}"
    end

  end
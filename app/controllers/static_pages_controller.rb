class StaticPagesController < ApplicationController
  def home
    puts "我在执行home函数"
    #   只显示正在进行中的活动 0-正在审核 1-正在进行 2-审核失败 3-报名结束
    @activities = Activity.where(AcStatus:"1")
    @amusement_activities = Activity.where(AcClass:"娱乐",AcStatus:"1")
    @sports_activities = Activity.where(AcClass:"运动",AcStatus:"1")
    @lecture_activities = Activity.where(AcClass:"讲座",AcStatus:"1")
    @tour_activities = Activity.where(AcClass:"旅游",AcStatus:"1")
    @party_activities = Activity.where(AcClass:"聚餐",AcStatus:"1")
  end

  def help
    puts "我在执行help函数"
    @activities = Activity.where(AcStatus:"1")
  end

  def schoolSelect

  end

  def getTimeBySelect(value)
    puts "正在执行getTimeBySelect"+value
    #处理时间 0-今天 1-明天 2-本周 3-本月 4-近期（3个月）
    case value
    when '0'
      return [Time.now.beginning_of_day,Time.now.at_end_of_day]
    when '1'
      return [(Time.now + 1.day).beginning_of_day,(Time.now + 1.day).at_end_of_day]
    when '2'
      return [Time.now.at_beginning_of_week,Time.now.at_end_of_week]
    when '3'
      return [Time.now.beginning_of_month,Time.now.end_of_month]
    when '4'
      return [(Time.now - 2.month).beginning_of_month,(Time.now + 1.month).end_of_month]
    end
  end

  def filterBySelect
    puts "我在执行filterBySelect函数"
    # month_id = params[:month_id]
    # # filter activities by AcClass
    # @activities = Activity.where(AcClass:"讲座")
    if params[:AcClass].nil?
      @activities = Activity.where(AcStatus:"1")
    else
      @activities = Activity.where(AcStatus:"1").like_any(['AcClass'],params[:AcClass])
    end

        
    if !params[:AcStartTime].nil?
      params[:AcStartTime] = getTimeBySelect(params[:AcStartTime][0])
      puts params[:AcStartTime][0]
      puts params[:AcStartTime][1]
      @activities = @activities.where("AcStartTime >= ?",params[:AcStartTime][0])
      @activities = @activities.where("AcStartTime <= ?",params[:AcStartTime][1])
    end
  
    respond_to do |format|
      # format.html { redirect_to @activities, notice: 'Activity was successfully created.' }
      # format.json { render '/help', status: :ok, location: @activities }
      # format.html { redirect_to @activity, notice: '活动修改成功!' }
      # format.json { render :show, status: :ok, location: @activity }
      # format.html { redirect_to('/help') }    
      #Render just the table for the ajax request:
      format.html { render partial: "shared/table" }
    end
  end

end

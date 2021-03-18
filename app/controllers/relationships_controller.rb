class RelationshipsController < ApplicationController
  before_action :set_relationship, only: [:show, :edit, :update, :destroy]
  skip_before_action :verify_authenticity_token, only:[:create]
  # GET /relationships
  # GET /relationships.json
  def index
    @relationships = Relationship.all
  end

  # GET /relationships/1
  # GET /relationships/1.json
  def show
  end

  # GET /relationships/new
  def new
    @relationship = Relationship.new
  end

  # GET /relationships/1/edit
  def edit
  end

  # POST /relationships
  # POST /relationships.json
=begin
  def create
    @relationship = Relationship.new(relationship_params)

    respond_to do |format|
      if @relationship.save
        format.html { redirect_to @relationship, notice: 'Relationship was successfully created.' }
        format.json { render :show, status: :created, location: @relationship }
      else
        format.html { render :new }
        format.json { render json: @relationship.errors, status: :unprocessable_entity }
      end
    end
  end
=end

  #创建关系，使用户加入活动
  def create
    #使用隐藏域提交的followed_act_id查找活动
    @activity = Activity.find(params[:followed_act_id])
    #当前用户加入活动
    @current_user = User.find_by(usermobile: session[:mobile])
    @current_user.follow(@activity)
    #使用 respond_to 方法，根据请求的类型生成合适的响应
    respond_to do |format|
      #重定向至活动资料页面
      format.html { redirect_to @activity}
      format.js
    end
  end


  # PATCH/PUT /relationships/1
  # PATCH/PUT /relationships/1.json
  def update
    respond_to do |format|
      if @relationship.update(relationship_params)
        format.html { redirect_to @relationship, notice: 'Relationship was successfully updated.' }
        format.json { render :show, status: :ok, location: @relationship }
      else
        format.html { render :edit }
        format.json { render json: @relationship.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /relationships/1
  # DELETE /relationships/1.json

  #用户退出activity活动
  def destroy
    #查找关系中“被加入”的活动
    @activity = Relationship.find(params[:id]).followed_act
    #退出活动
    @current_user = User.find_by(usermobile: session[:mobile])
    @current_user.unfollow(@activity)
    respond_to do |format|
      #重定向至活动资料页面
      format.html { redirect_to @activity }
      format.js
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_relationship
      @relationship = Relationship.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def relationship_params
      params.require(:relationship).permit(:follower_user_id, :followed_act_id)
    end
end

class UsersController < ApplicationController
  include UsersHelper

  def show
    @user = User.find(params[:id])
  end

  def new
  end

  def index
    @users = User.all
  end
  # POST /users/temporary

  def temporary
    mobile=params[:user][:usermobile]#手机号
    unless User.find_by(usermobile: mobile).nil?
      flash.now[:danger] = "注册失败，已经存在该账号！"
      render 'new'
    else
      vcode=rand(1000..9999).to_s  
      session[:mobile]=mobile
      session[:vcode]=vcode
      sendvcode(mobile,vcode)#进行验证码发送的help方法，尽量不要使用，免费短信有限。。。
      redirect_to :action => 'info0'
    end
  end

  def info0
    if session[:mobile]==""
      render 'new'
    end
  end

  def verify
    unless User.find_by(usermobile: session[:mobile]).nil?
      flash.now[:danger] = "注册失败，已经存在该账号！"
      render 'new'
    end
    puts "验证码实例"+params[:user][:vcode] 
    unless session[:vcode]==params[:user][:vcode]   #验证的方法暂时注释，这个和上边的发送验证码的是关联的
      flash.now[:danger] = "注册失败，验证码错误！" 
        clearsession
        render 'new'
    else
      redirect_to :action => 'info'
    end
    
  end


  def info
    if session[:mobile]==""
      render 'new'
    end
  end

  def addinfo
     unless User.find_by(usermobile: session[:mobile]).nil? 
      flash.now[:danger] = "注册失败，已经存在该账号！"
      render 'new'
     end
     

      user = User.new()
      user.usermobile = session[:mobile]
      user.password = params[:user][:password]
      user.password_confirmation = params[:user][:password_confirmation]
      user.usernickname=params[:user][:usernickname]
      user.username=params[:user][:username]
      user.usersex=params[:user][:usersex]
      user.userid=params[:user][:userid]
      user.usercollege=params[:user][:usercollege]
      user.userbirth=params[:user][:userbirth]
      user.userintro=params[:user][:userintro]
      user.userimage="/assets/co.jpg"
      
      

      if user.save
        session[:mobile]=nil;
        puts "恭喜你，注册成功！"
        redirect_to login_path
      else
          flash.now[:danger] = "注册失败，用户信息添加错误！"
          render 'info'               
      end   
  end
  

  #通过id查询用户，并且通过following检索该用户参加的活动 
  def following
    @title = "全部活动" 
    @user  = User.find(params[:id])
    @activitys = @user.following.paginate(page: params[:page])
    render 'show_following'
  end


  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find_by(usermobile: session[:mobile])
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:usermobile, :password_digest,:usernickname,
                        :username,:usersex,:userbirth,:usercollege,:userid,:userintro)
  end

end

class SessionsController < ApplicationController
  include UsersHelper
  include SessionsHelper

  
  def new
    if logged_in?
      puts "已登录"
      #需要在下边添加登陆跳转
      redirect_to root_url

   else
      render "new"
   end
  end

  def new2
  end

  def new3
    if logged_in?
      puts "已登录"
      #需要在下边添加登陆跳转
      redirect_to root_url

   else
      render "new3"
   end
  end


  def create

      mobile=params[:session][:usermobile]
      @user = User.find_by(usermobile: mobile)
      if @user.nil?
          flash.now[:danger] = "登录失败，用户名不存在！"
          render 'new'
      else
        vcode=rand(1000..9999).to_s
        session[:mobile]=mobile
        session[:vcode]=vcode
        sendvcode(mobile,vcode)
      
        #render 'info'
        redirect_to :action => 'new2'
      end
    end

    def create2
     
      @user = User.find_by(usermobile: session[:mobile])
    
      if @user.nil?
        flash.now[:danger] = "登录失败，用户名不存在！"
        render 'new'
      else
        unless session[:vcode]==params[:session][:vcode]    
          flash.now[:danger] = "登录失败，验证码错误！"
          clearsession
          render 'new'
        else      
            puts "登陆成功" 
            render "static_pages/home"   
        end
      end  
    end


    def create3
      mobile=params[:session][:usermobile]

      @user = User.find_by(usermobile: mobile)
      if @user.nil?
        flash.now[:danger] = "登录失败，用户名不存！"
        render 'new3'
      else
        if !!@user.authenticate(params[:session][:password])
          session[:mobile]=mobile
          puts "登陆成功"
          #需要在下边添加登陆跳转
          # render "static_pages/home"
          redirect_to root_url
          
        else      
          flash.now[:danger] = "登录失败，密码错误！"
          render 'new3'
        end  
      end     
    end  
end


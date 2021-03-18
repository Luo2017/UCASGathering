module SessionsHelper
  # 返回当前系统登录用户
  def current_user
    @current_user ||= User.find_by(usermobile: session[:mobile])
  end

  # 返回当前是否存在已登录用户
  def logged_in?
    if current_user.present?
      true
    else
      false
    end
  end

  # 对当前用户做登出操作
  def log_out
    session.delete(:mobile)
    @current_user==nil
  end

  def current_user?(user)
    user == current_user
  end
end

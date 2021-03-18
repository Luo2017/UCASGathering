class ApplicationController < ActionController::Base
    include SessionsHelper

    # 确保用户已经登录
    def logged_in_user
        # 没有登录则重定向到登录界面
        unless logged_in?
            redirect_to login_3_path
        end
    end
end

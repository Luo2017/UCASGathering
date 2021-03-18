require 'rest-client'

module UsersHelper

    def sendvcode(mobile,random) 
        puts mobile
        puts random

        url="http://106.ihuyi.com/webservice/sms.php?method=Submit"
 
        account="C23208413"
        password="75500244ec8cc451ce0e3d7922c6030b "
        mobile=mobile.to_i
        random=random.to_i      
        puts mobile
        puts random
        response = RestClient.post url, {account: account, password: password,
            mobile: mobile,content: "您的验证码是：#{random}。请不要把验证码泄露给其他人。"}

        
        puts response.code
        puts response.cookies
        puts response.headers
        puts response.body

    end


    def clearsession
        session[:vcode]=nil;
        session[:mobile]=nil;
    end
end

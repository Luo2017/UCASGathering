Rails.application.routes.draw do

  resources :relationships
  #用户管理，活动管理
  get 'admin/show'
  get 'admin/activityshow'
  get 'admin/activity_allow'
  get 'admin/activity_fail'
  get 'admin/myActivity'
  get 'admin/createMyActivity'
  get 'admin/personal'
  get 'admin/delete'
  get 'admin/update'
  get 'sessions/new'
  resources :users

  get 'static_pages/home'
  get 'static_pages/help'
  get 'static_pages/schoolSelect'
  get 'static_pages/filterBySelect'
  # 根路由
  root 'static_pages#home'
  # 具名路由
  get  '/help',    to: 'static_pages#help'
  get  '/schoolSelect',  to: 'static_pages#schoolSelect'
  get "/search" => "search#index", :as => "search"
  resources :activities do 
    collection do
      get :search
      # get :filterBySelect
    end
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  
  get  'temporary', to: 'users#new'
  post 'temporary', to: 'users#temporary'


  get  'info0', to: 'users#info0'
  post 'info0', to: 'users#verify'
  patch 'info0', to: 'users#verify'

  get  'info', to: 'users#info'
  post 'info', to: 'users#addinfo'
  patch 'info', to: 'users#addinfo'
 
  resources :sessions
  #手机&验证码登录过程 login->login2->完成
  get    'login',   to: 'sessions#new'  
  post   'login',   to: 'sessions#create'
  get    'login2',   to: 'sessions#new2'
  post 'login2', to: 'sessions#create2'
  patch 'login2', to: 'sessions#create2'
  #手机&密码登录过程 login3
  get    'login3',   to: 'sessions#new3'
  post   'login3',   to: 'sessions#create3', as: 'login_3' 
  #get ':controller(/:action(/:id))'


  # 活动相关路由begin

  resources :activities
  get '/new_activity', to: 'activities#new' # 用于创建活动
  post '/create_activity', to: 'activities#create' 
  # 修改活动没有创建具名路由
  post '/update_activity/:id', to: 'activities#update'  # 用于修改活动内容表单，基于post请求而不是默认的patch请求
  get '/destroy_activity/:id', to: 'activities#destroy' # 用于删除活动
  get '/nc_user_error', to: 'activities#not_correct_user', as: 'nc_user' # 用于没有权限时的错误警告，具名路由nc_user_path
  get '/ac_error', to: 'activities#ac_error_occured', as: 'ac_error' # 用于没有权限时的错误警告，具名路由nc_user_path
  
  # 活动相关路由end




  #成员路由，为加入活动的列表页面增加路由,生成具名路由following_user_path
  resources :users do
    member  do
      get :following
    end
  end

  #生成具名路由followers_activity_path
  resources :activities do
    member do
      get :followers
    end
  end
  
  #为relationships资源创建路由
  resources :relationships, only: [:create, :destroy]

  #个人页具名路由
  get '/my_page', to: 'my_page#home' # 用于创建活动
  get '/my_page_info', to: 'my_page#showMyInfo' # 用于创建活动
  get '/my_page_activities', to: 'my_page#showMyActivities' # 用于创建活动
  get '/my_page_activities_joined', to: 'my_page#showMyActivitiesJoined' # 用于创建活动


end


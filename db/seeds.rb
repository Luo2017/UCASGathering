# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
user = User.create(usermobile: '13379304436',password: 'wangbo',password_confirmation: 'wangbo',usernickname: 'hairlessman',username: 'wangbo',
    usersex: 'male',userid: '1',usercollege: 'ucas')
activity = Activity.create(AcTitle: '打篮球', AcSitu: '操场', AcStatus: '1')

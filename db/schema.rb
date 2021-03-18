# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_01_08_152137) do

  create_table "activities", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "UserId"
    t.integer "AcId"
    t.string "AcStatus"
    t.string "AcClass"
    t.string "AcTitle"
    t.string "AcSitu"
    t.datetime "AcStartTime"
    t.datetime "AcEndTime"
    t.integer "AcCount"
    t.string "AcDura"
    t.integer "AcIsPra"
    t.string "AcPass"
    t.text "AcIntro"
    t.string "AcUsersGroup"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "picture"
    t.index ["UserId"], name: "index_activities_on_UserId"
  end

  create_table "relationships", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "follower_user_id"
    t.integer "followed_act_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "usermobile"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "usernickname"
    t.string "username"
    t.string "usersex"
    t.date "userbirth"
    t.string "userid"
    t.string "usercollege"
    t.string "userintro"
    t.string "vcode"
    t.string "userimage"
  end

  add_foreign_key "activities", "users", column: "UserId"
end

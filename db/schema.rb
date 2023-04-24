# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_04_16_051941) do
  create_table "products", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "descriptions"
    t.integer "qty"
    t.string "unit"
    t.decimal "cost_price", precision: 10, scale: 2
    t.decimal "sell_price", precision: 10, scale: 2
    t.string "prod_pic"
    t.string "category"
    t.decimal "sale_price", precision: 10, scale: 2
    t.integer "alert_level"
    t.integer "critical_level"
    t.timestamp "datecreated", default: -> { "CURRENT_TIMESTAMP" }
    t.timestamp "dateupdated"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "lastname"
    t.string "firstname"
    t.string "emailadd"
    t.string "mobileno"
    t.string "username"
    t.string "password"
    t.string "role", default: "USER"
    t.text "secretkey"
    t.text "picture"
    t.integer "isactivated", default: 0
    t.integer "isblocked", default: 0
    t.integer "mailtoken", default: 0
    t.text "qrcodeurl"
    t.timestamp "datecreated", default: -> { "CURRENT_TIMESTAMP" }
    t.timestamp "dateupdated"
    t.string "otp_secret_key"
    t.index ["emailadd"], name: "index_users_on_emailadd", unique: true
    t.index ["lastname", "firstname"], name: "index_users_on_lastname_and_firstname", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

end

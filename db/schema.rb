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

ActiveRecord::Schema[7.0].define(version: 2022_07_17_210909) do
  create_table "accounts", force: :cascade do |t|
    t.string "name"
    t.string "nature"
    t.float "balance"
    t.string "currency_code"
    t.string "cards"
    t.integer "posted_transactions_count"
    t.integer "pending_transactions_count"
    t.integer "connection_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "account_string_id"
    t.index ["connection_id"], name: "index_accounts_on_connection_id"
  end

  create_table "connections", force: :cascade do |t|
    t.string "secret"
    t.string "provider_id"
    t.string "provider_code"
    t.string "provider_name"
    t.boolean "daily_refresh"
    t.datetime "last_success_at"
    t.string "status"
    t.string "country_code"
    t.datetime "next_refresh_possible_at"
    t.string "store_credentials"
    t.boolean "show_consent_confirmation"
    t.string "last_consent_id"
    t.integer "customer_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "connection_string_id"
    t.index ["customer_id"], name: "index_connections_on_customer_id"
  end

  create_table "customers", force: :cascade do |t|
    t.string "identifier"
    t.string "secret"
    t.datetime "blocked_at"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_customers_on_user_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.string "mode"
    t.string "status"
    t.datetime "made_on"
    t.float "amount"
    t.string "currency_code"
    t.string "description"
    t.string "category"
    t.boolean "duplicated"
    t.string "merchant_id"
    t.float "original_amount"
    t.string "original_currency_code"
    t.datetime "posting_date"
    t.datetime "time"
    t.string "string"
    t.integer "account_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_transactions_on_account_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "accounts", "connections"
  add_foreign_key "connections", "customers"
  add_foreign_key "customers", "users"
  add_foreign_key "transactions", "accounts"
end

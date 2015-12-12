# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20151212165352) do

  create_table "access_tokens", force: :cascade do |t|
    t.integer "volonter_id", limit: 4
    t.string  "value",       limit: 255
  end

  add_index "access_tokens", ["value"], name: "index_access_tokens_on_value", using: :btree
  add_index "access_tokens", ["volonter_id"], name: "index_access_tokens_on_volonter_id", using: :btree

  create_table "admin_users", force: :cascade do |t|
    t.string   "first_name",      limit: 255, default: "",    null: false
    t.string   "last_name",       limit: 255, default: "",    null: false
    t.string   "role",            limit: 255,                 null: false
    t.string   "email",           limit: 255,                 null: false
    t.boolean  "status",                      default: false
    t.string   "token",           limit: 255,                 null: false
    t.string   "password_digest", limit: 255,                 null: false
    t.string   "preferences",     limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree

  create_table "kids", force: :cascade do |t|
    t.integer  "status",      limit: 4,     default: 0
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.string   "name",        limit: 255
    t.string   "address",     limit: 255
    t.integer  "age",         limit: 4
    t.string   "video",       limit: 255
    t.text     "description", limit: 65535
  end

  add_index "kids", ["address"], name: "index_kids_on_address", using: :btree
  add_index "kids", ["age"], name: "index_kids_on_age", using: :btree
  add_index "kids", ["name"], name: "index_kids_on_name", using: :btree
  add_index "kids", ["status"], name: "index_kids_on_status", using: :btree

  create_table "profiles", force: :cascade do |t|
    t.string   "image",      limit: 255
    t.integer  "user_id",    limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "profiles", ["user_id"], name: "index_profiles_on_user_id", using: :btree

  create_table "user_authorizations", force: :cascade do |t|
    t.string   "provider",   limit: 255
    t.string   "uid",        limit: 255
    t.integer  "user_id",    limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "user_authorizations", ["uid"], name: "index_user_authorizations_on_uid", using: :btree
  add_index "user_authorizations", ["user_id"], name: "index_user_authorizations_on_user_id", using: :btree

  create_table "user_kids", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.integer  "kid_id",     limit: 4
    t.integer  "status",     limit: 4, default: 0
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  add_index "user_kids", ["kid_id"], name: "index_user_kids_on_kid_id", using: :btree
  add_index "user_kids", ["status"], name: "index_user_kids_on_status", using: :btree
  add_index "user_kids", ["user_id"], name: "index_user_kids_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "name",                   limit: 255
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["name"], name: "index_users_on_name", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "volonter_kids", force: :cascade do |t|
    t.integer  "volonter_id", limit: 4
    t.integer  "kid_id",      limit: 4
    t.integer  "status",      limit: 4,   default: 0
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "video",       limit: 255
  end

  add_index "volonter_kids", ["kid_id"], name: "index_volonter_kids_on_kid_id", using: :btree
  add_index "volonter_kids", ["status"], name: "index_volonter_kids_on_status", using: :btree
  add_index "volonter_kids", ["volonter_id"], name: "index_volonter_kids_on_volonter_id", using: :btree

  create_table "volonters", force: :cascade do |t|
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
  end

  add_index "volonters", ["email"], name: "index_volonters_on_email", unique: true, using: :btree
  add_index "volonters", ["reset_password_token"], name: "index_volonters_on_reset_password_token", unique: true, using: :btree

end

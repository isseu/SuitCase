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

ActiveRecord::Schema.define(version: 20150522220701) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "case_records", force: :cascade do |t|
    t.integer  "case_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "case_records", ["case_id"], name: "index_case_records_on_case_id", using: :btree
  add_index "case_records", ["user_id"], name: "index_case_records_on_user_id", using: :btree

  create_table "case_users", force: :cascade do |t|
    t.integer  "case_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "case_users", ["case_id"], name: "index_case_users_on_case_id", using: :btree
  add_index "case_users", ["user_id"], name: "index_case_users_on_user_id", using: :btree

  create_table "cases", force: :cascade do |t|
    t.string   "rol"
    t.datetime "fecha"
    t.string   "tribunal"
    t.text     "caratula"
    t.integer  "info_id"
    t.string   "info_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "client_users", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "client_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "client_users", ["client_id"], name: "index_client_users_on_client_id", using: :btree
  add_index "client_users", ["user_id"], name: "index_client_users_on_user_id", using: :btree

  create_table "clients", force: :cascade do |t|
    t.string   "name",                            null: false
    t.string   "rut"
    t.string   "first_lastname"
    t.string   "second_lastname"
    t.boolean  "is_company",      default: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  create_table "info_civils", force: :cascade do |t|
    t.integer  "case_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "info_civils", ["case_id"], name: "index_info_civils_on_case_id", using: :btree

  create_table "info_cortes", force: :cascade do |t|
    t.integer  "case_id"
    t.string   "numero_ingreso"
    t.string   "ubicacion"
    t.string   "corte"
    t.date     "fecha_ubicacion"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "info_cortes", ["case_id"], name: "index_info_cortes_on_case_id", using: :btree

  create_table "info_laborals", force: :cascade do |t|
    t.integer  "case_id"
    t.string   "rit"
    t.string   "ruc"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "info_laborals", ["case_id"], name: "index_info_laborals_on_case_id", using: :btree

  create_table "info_supremas", force: :cascade do |t|
    t.integer  "case_id"
    t.string   "numero_ingreso"
    t.string   "tipo_recurso"
    t.string   "ubicacion"
    t.string   "corte"
    t.date     "fecha_ubicacion"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "info_supremas", ["case_id"], name: "index_info_supremas_on_case_id", using: :btree

  create_table "litigantes", force: :cascade do |t|
    t.integer  "case_id"
    t.string   "participante"
    t.string   "rut"
    t.string   "persona"
    t.string   "nombre"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "litigantes", ["case_id"], name: "index_litigantes_on_case_id", using: :btree

  create_table "notifications", force: :cascade do |t|
    t.integer  "user_id"
    t.text     "text"
    t.boolean  "read"
    t.text     "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "notifications", ["user_id"], name: "index_notifications_on_user_id", using: :btree

  create_table "possible_names", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "first_lastname"
    t.string   "second_lastname"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "possible_names", ["user_id"], name: "index_possible_names_on_user_id", using: :btree

  create_table "receptors", force: :cascade do |t|
    t.integer  "info_civil_id"
    t.string   "notebook"
    t.string   "dat"
    t.string   "state"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "receptors", ["info_civil_id"], name: "index_receptors_on_info_civil_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "role"
    t.string   "rut",                    default: "", null: false
    t.string   "name",                   default: "", null: false
    t.string   "first_lastname",         default: "", null: false
    t.string   "second_lastname",        default: "", null: false
    t.string   "password_judicial"
    t.string   "telephone"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "info_civils", "cases"
  add_foreign_key "info_cortes", "cases"
  add_foreign_key "info_laborals", "cases"
  add_foreign_key "info_supremas", "cases"
  add_foreign_key "receptors", "info_civils"
end

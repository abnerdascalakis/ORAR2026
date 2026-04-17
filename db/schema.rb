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

ActiveRecord::Schema[8.1].define(version: 2026_04_15_161802) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "a_distritos", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "nome"
    t.datetime "updated_at", null: false
  end

  create_table "a_modalidades", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "limite"
    t.string "nome"
    t.datetime "updated_at", null: false
  end

  create_table "a_sexos", id: :integer, default: -> { "nextval('g_sexos_id_seq'::regclass)" }, force: :cascade do |t|
    t.datetime "created_at", precision: nil, default: -> { "CURRENT_TIMESTAMP" }
    t.string "descricao", limit: 100, null: false
    t.datetime "updated_at", precision: nil, default: -> { "CURRENT_TIMESTAMP" }

    t.unique_constraint ["descricao"], name: "g_sexos_descricao_key"
  end

  create_table "a_sociedades", force: :cascade do |t|
    t.bigint "a_distrito_id", null: false
    t.datetime "created_at", null: false
    t.string "nome"
    t.datetime "updated_at", null: false
    t.index ["a_distrito_id"], name: "index_a_sociedades_on_a_distrito_id"
  end

  create_table "inscricao_modalidades", force: :cascade do |t|
    t.bigint "a_modalidade_id", null: false
    t.datetime "created_at", null: false
    t.bigint "inscricao_id", null: false
    t.datetime "updated_at", null: false
    t.index ["a_modalidade_id"], name: "index_inscricao_modalidades_on_a_modalidade_id"
    t.index ["inscricao_id"], name: "index_inscricao_modalidades_on_inscricao_id"
  end

  create_table "inscricoes", force: :cascade do |t|
    t.bigint "a_distrito_id", null: false
    t.bigint "a_sexo_id", null: false
    t.bigint "a_sociedade_id", null: false
    t.datetime "created_at", null: false
    t.string "nome"
    t.datetime "updated_at", null: false
    t.index ["a_distrito_id"], name: "index_inscricoes_on_a_distrito_id"
    t.index ["a_sexo_id"], name: "index_inscricoes_on_a_sexo_id"
    t.index ["a_sociedade_id"], name: "index_inscricoes_on_a_sociedade_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "a_sociedades", "a_distritos"
  add_foreign_key "inscricao_modalidades", "a_modalidades"
  add_foreign_key "inscricao_modalidades", "inscricoes"
  add_foreign_key "inscricoes", "a_distritos"
  add_foreign_key "inscricoes", "a_sexos"
  add_foreign_key "inscricoes", "a_sociedades"
end

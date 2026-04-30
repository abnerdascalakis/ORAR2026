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

ActiveRecord::Schema[8.1].define(version: 2026_04_30_130000) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "distritos", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "nome"
    t.datetime "updated_at", null: false
  end

  create_table "equipes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "distrito_id"
    t.bigint "modalidade_id", null: false
    t.string "nome", null: false
    t.datetime "updated_at", null: false
    t.index ["distrito_id"], name: "index_equipes_on_distrito_id"
    t.index ["modalidade_id", "nome"], name: "index_equipes_on_modalidade_id_and_nome", unique: true
    t.index ["modalidade_id"], name: "index_equipes_on_modalidade_id"
  end

  create_table "eventos", force: :cascade do |t|
    t.integer "ano"
    t.datetime "created_at", null: false
    t.date "data_fim"
    t.date "data_inicio"
    t.string "descricao"
    t.string "status"
    t.datetime "updated_at", null: false
  end

  create_table "inscricao_modalidades", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "inscricao_id", null: false
    t.bigint "modalidade_id", null: false
    t.datetime "updated_at", null: false
    t.index ["inscricao_id"], name: "index_inscricao_modalidades_on_inscricao_id"
    t.index ["modalidade_id"], name: "index_inscricao_modalidades_on_modalidade_id"
  end

  create_table "inscricoes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "distrito_id", null: false
    t.bigint "evento_id", null: false
    t.bigint "pessoa_id", null: false
    t.bigint "sociedade_id"
    t.datetime "updated_at", null: false
    t.index ["distrito_id"], name: "index_inscricoes_on_distrito_id"
    t.index ["evento_id"], name: "index_inscricoes_on_evento_id"
    t.index ["pessoa_id"], name: "index_inscricoes_on_pessoa_id"
    t.index ["sociedade_id"], name: "index_inscricoes_on_sociedade_id"
  end

  create_table "membro_equipes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "equipe_id", null: false
    t.bigint "inscricao_modalidade_id", null: false
    t.datetime "updated_at", null: false
    t.index ["equipe_id", "inscricao_modalidade_id"], name: "index_membro_equipes_on_equipe_and_inscricao", unique: true
    t.index ["equipe_id"], name: "index_membro_equipes_on_equipe_id"
    t.index ["inscricao_modalidade_id"], name: "index_membro_equipes_on_inscricao_modalidade_id"
  end

  create_table "modalidades", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.boolean "individual", default: false, null: false
    t.integer "limite"
    t.string "nome"
    t.datetime "updated_at", null: false
  end

  create_table "pessoas", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "gmail"
    t.string "nome"
    t.bigint "sexo_id", null: false
    t.string "telefone"
    t.datetime "updated_at", null: false
    t.index ["sexo_id"], name: "index_pessoas_on_sexo_id"
  end

  create_table "sexos", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "nome"
    t.datetime "updated_at", null: false
  end

  create_table "sociedades", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "distrito_id", null: false
    t.string "nome"
    t.datetime "updated_at", null: false
    t.index ["distrito_id", "nome"], name: "index_sociedades_on_distrito_id_and_nome", unique: true
    t.index ["distrito_id"], name: "index_sociedades_on_distrito_id"
  end

  create_table "sociedades_eventos", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "evento_id", null: false
    t.bigint "sociedade_id", null: false
    t.datetime "updated_at", null: false
    t.index ["evento_id"], name: "index_sociedades_eventos_on_evento_id"
    t.index ["sociedade_id"], name: "index_sociedades_eventos_on_sociedade_id"
  end

  create_table "users", force: :cascade do |t|
    t.boolean "admin", default: false, null: false
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

  add_foreign_key "equipes", "distritos"
  add_foreign_key "equipes", "modalidades"
  add_foreign_key "inscricao_modalidades", "inscricoes"
  add_foreign_key "inscricao_modalidades", "modalidades"
  add_foreign_key "inscricoes", "distritos"
  add_foreign_key "inscricoes", "eventos"
  add_foreign_key "inscricoes", "pessoas"
  add_foreign_key "inscricoes", "sociedades"
  add_foreign_key "membro_equipes", "equipes"
  add_foreign_key "membro_equipes", "inscricao_modalidades"
  add_foreign_key "pessoas", "sexos"
  add_foreign_key "sociedades", "distritos"
  add_foreign_key "sociedades_eventos", "eventos"
  add_foreign_key "sociedades_eventos", "sociedades"
end

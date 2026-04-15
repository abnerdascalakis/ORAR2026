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

ActiveRecord::Schema[8.1].define(version: 2026_04_15_000507) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "a_sexos", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: nil, default: -> { "CURRENT_TIMESTAMP" }
    t.string "descricao", limit: 100, null: false
    t.datetime "updated_at", precision: nil, default: -> { "CURRENT_TIMESTAMP" }
  end

  create_table "inscricoes", force: :cascade do |t|
    t.boolean "aceitou_termos", default: false, null: false
    t.datetime "created_at", null: false
    t.date "data_nascimento", null: false
    t.string "distrito", null: false
    t.string "email", null: false
    t.string "nome_participante", null: false
    t.bigint "sexo_id", null: false
    t.bigint "sociedade_jovem_id", null: false
    t.datetime "updated_at", null: false
    t.index ["sexo_id"], name: "index_inscricoes_on_sexo_id"
    t.index ["sociedade_jovem_id"], name: "index_inscricoes_on_sociedade_jovem_id"
  end

  create_table "modalidades", force: :cascade do |t|
    t.boolean "ativa", default: true, null: false
    t.datetime "created_at", null: false
    t.string "descricao"
    t.string "nome", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sociedade_jovens", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "distrito"
    t.string "nome", null: false
    t.datetime "updated_at", null: false
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

  add_foreign_key "inscricoes", "a_sexos", column: "sexo_id"
  add_foreign_key "inscricoes", "sociedade_jovens", column: "sociedade_jovem_id"
end

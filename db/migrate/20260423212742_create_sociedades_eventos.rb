class CreateSociedadesEventos < ActiveRecord::Migration[8.1]
  def change
    create_table :sociedades_eventos do |t|
      t.references :sociedade, null: false, foreign_key: true
      t.references :evento, null: false, foreign_key: true

      t.timestamps
    end
  end
end

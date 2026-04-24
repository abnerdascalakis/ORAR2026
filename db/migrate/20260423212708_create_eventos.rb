class CreateEventos < ActiveRecord::Migration[8.1]
  def change
    create_table :eventos do |t|
      t.string :descricao
      t.integer :ano
      t.date :data_inicio
      t.date :data_fim
      t.string :status

      t.timestamps
    end
  end
end

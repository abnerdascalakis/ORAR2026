class CreatePresencasRefeicoesAndConsumos < ActiveRecord::Migration[8.1]
  def change
    create_table :presencas do |t|
      t.references :inscricao, null: false, foreign_key: true
      t.references :evento, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.datetime :registrada_em, null: false

      t.timestamps
    end

    add_index :presencas, [ :inscricao_id, :evento_id ], unique: true

    create_table :refeicoes do |t|
      t.references :evento, null: false, foreign_key: true
      t.string :nome, null: false
      t.date :data, null: false
      t.time :horario_inicio
      t.time :horario_fim

      t.timestamps
    end

    add_index :refeicoes, [ :evento_id, :data, :nome ], unique: true

    create_table :consumo_alimentacoes do |t|
      t.references :inscricao, null: false, foreign_key: true
      t.references :refeicao, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.datetime :consumido_em, null: false

      t.timestamps
    end

    add_index :consumo_alimentacoes, [ :inscricao_id, :refeicao_id ], unique: true
  end
end

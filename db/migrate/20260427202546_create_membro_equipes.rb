class CreateMembroEquipes < ActiveRecord::Migration[8.1]
  def change
    create_table :membro_equipes do |t|
      t.references :equipe, null: false, foreign_key: true
      t.references :inscricao_modalidade, null: false, foreign_key: true

      t.timestamps
    end
  end
end

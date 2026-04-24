class CreateInscricaoModalidades < ActiveRecord::Migration[8.1]
  def change
    create_table :inscricao_modalidades do |t|
      t.references :modalidade, null: false, foreign_key: true
      t.references :inscricao, null: false, foreign_key: { to_table: :inscricaos }

      t.timestamps
    end
  end
end

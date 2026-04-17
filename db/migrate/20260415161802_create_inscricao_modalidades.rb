class CreateInscricaoModalidades < ActiveRecord::Migration[8.1]
  def change
    create_table :inscricao_modalidades do |t|
      t.references :inscricao, null: false, foreign_key: true
      t.references :a_modalidade, null: false, foreign_key: true

      t.timestamps
    end
  end
end

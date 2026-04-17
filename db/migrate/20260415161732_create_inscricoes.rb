class CreateInscricoes < ActiveRecord::Migration[8.1]
  def change
    create_table :inscricoes do |t|
      t.string :nome
      t.references :a_sexo, null: false, foreign_key: true
      t.references :a_distrito, null: false, foreign_key: true
      t.references :a_sociedade, null: false, foreign_key: true

      t.timestamps
    end
  end
end

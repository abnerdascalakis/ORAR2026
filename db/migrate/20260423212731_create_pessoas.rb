class CreatePessoas < ActiveRecord::Migration[8.1]
  def change
    create_table :pessoas do |t|
      t.string :nome
      t.string :telefone
      t.string :gmail
      t.references :sexo, null: false, foreign_key: true

      t.timestamps
    end
  end
end

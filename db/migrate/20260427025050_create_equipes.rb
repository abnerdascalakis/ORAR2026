class CreateEquipes < ActiveRecord::Migration[8.1]
  def change
    create_table :equipes do |t|
      t.string :nome, null: false
      t.references :modalidade, null: false, foreign_key: true

      t.timestamps
    end

    add_index :equipes, [ :modalidade_id, :nome ], unique: true
  end
end

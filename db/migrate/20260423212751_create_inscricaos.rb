class CreateInscricaos < ActiveRecord::Migration[8.1]
  def change
    create_table :inscricaos do |t|
      t.references :sociedade, null: false, foreign_key: true
      t.references :pessoa, null: false, foreign_key: true

      t.timestamps
    end
  end
end

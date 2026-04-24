class CreateSociedades < ActiveRecord::Migration[8.1]
  def change
    create_table :sociedades do |t|
      t.string :nome
      t.references :distrito, null: false, foreign_key: true

      t.timestamps
    end
  end
end

class CreateASociedades < ActiveRecord::Migration[8.1]
  def change
    create_table :a_sociedades do |t|
      t.string :nome
      t.references :a_distrito, null: false, foreign_key: true

      t.timestamps
    end
  end
end

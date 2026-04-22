class CreateASexos < ActiveRecord::Migration[7.0]
  def change
    create_table :a_sexos do |t|
      t.string :nome, null: false

      t.timestamps
    end
  end
end
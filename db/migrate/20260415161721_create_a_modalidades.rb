class CreateAModalidades < ActiveRecord::Migration[8.1]
  def change
    create_table :a_modalidades do |t|
      t.string :nome
      t.integer :limite

      t.timestamps
    end
  end
end

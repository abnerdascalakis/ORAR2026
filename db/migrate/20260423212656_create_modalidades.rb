class CreateModalidades < ActiveRecord::Migration[8.1]
  def change
    create_table :modalidades do |t|
      t.string :nome
      t.integer :limite

      t.timestamps
    end
  end
end

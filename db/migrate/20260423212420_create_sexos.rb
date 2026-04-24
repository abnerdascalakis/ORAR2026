class CreateSexos < ActiveRecord::Migration[8.1]
  def change
    create_table :sexos do |t|
      t.string :nome

      t.timestamps
    end
  end
end

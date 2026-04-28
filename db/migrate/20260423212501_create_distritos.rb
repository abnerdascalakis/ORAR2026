class CreateDistritos < ActiveRecord::Migration[8.1]
  def change
    create_table :distritos do |t|
      t.string :nome

      t.timestamps
    end
  end
end

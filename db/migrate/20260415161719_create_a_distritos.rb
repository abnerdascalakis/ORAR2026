class CreateADistritos < ActiveRecord::Migration[8.1]
  def change
    create_table :a_distritos do |t|
      t.string :nome

      t.timestamps
    end
  end
end

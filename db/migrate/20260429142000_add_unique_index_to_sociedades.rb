class AddUniqueIndexToSociedades < ActiveRecord::Migration[8.1]
  def change
    add_index :sociedades, [ :distrito_id, :nome ], unique: true
  end
end

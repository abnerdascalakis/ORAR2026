class AddDistritoToEquipes < ActiveRecord::Migration[8.1]
  def change
    add_reference :equipes, :distrito, null: true, foreign_key: true
  end
end
